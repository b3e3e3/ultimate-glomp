class_name PlayerClimbingState extends PlayerState

@onready var idle_state: State = $"../Idle"
@onready var jumping_state: State = $"../Jumping"
@onready var attacking_state: State = $"../Attacking"
@onready var falling_state: State = $"../Falling"

@onready var slide_particles: GPUParticles3D = $"../../SlideParticles"

@export var jump_off_force = Vector3(0, 4.0, 0)
@export var side_swap_hold_time := 0.2
@export var slide_delay_time := 0.05

var should_slide := false


func on_enter(_previous_state: State, _data := {}) -> void:
	character.gravity_enabled = false
	character.velocity = Vector3.ZERO

	controller.force_direction = Vector3.ZERO

	should_slide = false

	player.get_node(^"Sprite").cancel_flip()
	player.combo_jump.reset()

	await get_tree().create_timer(slide_delay_time).timeout
	should_slide = true


func on_physics_update(_delta: float) -> void:
	var bodies := player.get_climbable_bodies_in_proximity()
	var climb_body := bodies[0] if not bodies.is_empty() else null

	if not climb_body:
		goto(falling_state)
		return

	var hor := controller.get_horizontal_input()

	var slide_speed := character.get_wall_slide_speed()

	if character.global_position.x > climb_body.global_position.x:
		character.direction.x = -1
	else: character.direction.x = 1

	slide_particles.emitting = false

	# climb side swapping
	if await check_for_swapping(side_swap_hold_time) and climb_body and climb_body.is_in_group(&"ClimbSwappable"):
		character.global_position.x += character.direction.x * 48
		character.direction.x *= -1

	# jump off climbable
	elif check_for_jumping(false): # 2nd condition is temp fix. TODO
		controller.force_direction = -character.last_direction
		var _dir := -character.last_direction.x
		var _speed := character.get_speed()
		if hor != 0 and sign(hor) != sign(_dir):
			_speed *= 2.22

		goto(jumping_state, {
			&'jump_force': jump_off_force + Vector3(_dir * _speed, 0, 0),
			&'just_jumped': false,
			&'just_climbed': true,
			# &'air_accel_speed': character.get_accel_speed(),
			&'air_decel_speed': 3,
			&'jumps': 1,
			&"jump_combo": 0
		})

	elif check_for_attacking():
		goto(attacking_state, {
			&'just_climbed': true,
		})

	elif character.is_on_floor():
		goto(idle_state, {
			&'just_climbed': true,
		})

	elif check_for_moving_vertical():# or character.velocity.y != 0:
		# TODO: figure out how to get player to stop at top of climbable
		var ver: float = controller.get_vertical_input() if not player.is_attacking else 0.0
		character.vertical_move(ver, 2.0 if ver < 0 else 1.5, 9999)

	elif should_slide and slide_speed != 0:
		character.vertical_move(-1, slide_speed)


	if character.velocity.y < 0:
		__emit_slide_particles()

func __emit_slide_particles():
	if slide_particles:
		slide_particles.emitting = true
		slide_particles.position.x = 0.25 * character.last_direction.x
		(slide_particles.process_material as ParticleProcessMaterial).direction.x = -character.last_direction.x

func on_exit() -> void:
	character.gravity_enabled = true
	character.velocity.y = 0

	should_slide = false
	if slide_particles:
		slide_particles.emitting = false

	get_tree().create_timer(0.3).timeout.connect(func():
		character.collision_shape.disabled= false
	, CONNECT_ONE_SHOT)
