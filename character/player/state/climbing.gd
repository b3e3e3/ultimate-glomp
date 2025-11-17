class_name PlayerClimbingState extends PlayerState

@onready var idle_state: State = $"../Idle"
@onready var jumping_state: State = $"../Jumping"
@onready var attacking_state: State = $"../Attacking"
@onready var falling_state: State = $"../Falling"

@onready var slide_particles: GPUParticles3D = $"../../SlideParticles"

@export var jump_off_force = Vector3(0, 4.0, 0)
@export var side_swap_hold_time := 0.2


func on_enter(_previous_state: State, _data := {}) -> void:
	# stop the character
	character.gravity_enabled = false
	character.velocity = Vector3.ZERO

	# disable our forced direction
	controller.force_direction = Vector3.ZERO

	# reset combo jump and cancel flip. TODO: don't reference sprite directly
	player.combo_jump.reset()
	player.get_node(^"Sprite").cancel_flip()

	# start the slide timer
	$SlideManager.should_slide = false


func on_physics_update(_delta: float) -> void:
	var bodies := player.get_climbable_bodies_in_proximity()
	var climb_body := bodies[0] if not bodies.is_empty() else null

	# if we don't actually have something to climb, don't
	if not climb_body:
		goto(falling_state)
		return

	# disbale slide particles
	slide_particles.emitting = false

	# get horizontal input
	var hor := controller.get_horizontal_input()

	# get how fast we should slide
	var slide_speed := character.get_wall_slide_speed()

	# update the character's direction based on the position relative to the climb body
	if character.global_position.x > climb_body.global_position.x:
		character.direction.x = -1
	else: character.direction.x = 1

	# if the surface is not slideable, OR we are able to climb
	var can_climb_like_ladder := not climb_body.is_in_group(&"Slideable") or slide_speed == 0

	# climb side swapping
	if await check_for_swapping(side_swap_hold_time) and climb_body and climb_body.is_in_group(&"ClimbSwappable"):
		character.global_position.x += character.direction.x * 0.48
		character.direction.x *= -1

	# jump off climbable
	elif check_for_jumping(false): # 2nd condition is temp fix. TODO
		var _speed := character.get_speed()
		var _accel := character.ACCEL_SPEED_AIR
		var _dir := -character.last_direction.x

		if not hor:
			controller.force_direction = -character.last_direction
		else:
			_speed *= 0.5

		goto(jumping_state, {
			&'jump_force': jump_off_force + Vector3(_dir * _speed, 0, 0),
			&'just_jumped': false,
			&'just_climbed': true,
			&'jumps': character.get_jumps_after_climbing(),
			# &"jump_combo": 0
		})

	# attacking
	elif check_for_attacking():
		goto(attacking_state, {
			&'just_climbed': true,
		})

	# landing on floor
	elif character.is_on_floor():
		goto(idle_state, {
			&'just_climbed': true,
		})

	# if we can climb the surface and we're trying to, move vertically
	elif check_for_moving_vertical() and can_climb_like_ladder:# or character.velocity.y != 0:
		# TODO: figure out how to get player to stop at top of climbable
		var ver: float = controller.get_vertical_input() if not player.is_attacking else 0.0
		character.vertical_move(ver, 2.0 if ver < 0 else 1.5, 9999)

	# if we should slide and we can't climb, slide down
	elif $SlideManager.should_slide:# and not can_climb_like_ladder:
		character.vertical_move(-1, slide_speed, 9999.0 \
						if character.velocity.y != 0 else character.get_accel_speed()
		)

	# if we shouldn't slide and aren't trying to move, but are moving, stop
	elif character.velocity.y != 0:
		character.vertical_move(0)


	__emit_slide_particles()


func __emit_slide_particles():
	if slide_particles and character.velocity.y < 0:
		slide_particles.emitting = true
		slide_particles.position.x = 0.25 * character.last_direction.x
		(slide_particles.process_material as ParticleProcessMaterial).direction.x = -character.last_direction.x

func on_exit() -> void:
	character.gravity_enabled = true
	character.velocity.y = 0

	$SlideManager.should_slide = false
	if slide_particles:
		slide_particles.emitting = false

	get_tree().create_timer(0.3).timeout.connect(func():
		character.collision_shape.disabled= false
	, CONNECT_ONE_SHOT)
