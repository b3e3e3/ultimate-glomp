class_name PlayerClimbingState extends PlayerState

@onready var jumping_state: State = $"../Jumping"

# var _old_jump_force: Vector2
@export var jump_off_force = Vector2(0, -300)

var side_swap_hold_time := 0.2

func on_enter(_previous_state: State, data := {}) -> void:
	character.gravity_enabled = false
	character.velocity = Vector2.ZERO
	character.collision_shape.disabled = true
# 	_old_jump_force = data.get(&'jump_force') if data.has(&'jump_force') else player.JUMP_VELOCITY

func on_physics_update(_delta: float) -> void:
	var hor := controller.get_horizontal_input()

	var bodies := player.get_climbable_bodies_in_proximity()
	var climb_body := bodies[0] if not bodies.is_empty() else null

	# check for climbing up/down
	if check_for_moving_vertical() or character.velocity.y != 0:
		var ver := controller.get_vertical_input()
		character.vertical_move(ver, 200 if ver > 0 else 150)

	# climb side swapping
	elif await check_for_swapping(side_swap_hold_time) and climb_body and climb_body.is_in_group(&"ClimbSwappable"):
		character.global_position.x += character.direction.x * 48
		character.direction.x *= -1

	# jump off climbable
	elif check_for_jumping():
		goto(jumping_state, {
			&'jump_force': jump_off_force + Vector2(character.direction.x * (-character.get_speed() * 1.7), 0),
			&'coyote_time': 0.7,
			&'just_jumped': false,
			# &'jumps': 1,
		})

	# super.on_physics_update(_delta)

func on_exit() -> void:
	character.gravity_enabled = true
	get_tree().create_timer(0.3).timeout.connect(func():
		character.collision_shape.disabled= false
	, CONNECT_ONE_SHOT)
