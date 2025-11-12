class_name PlayerAttackingState extends PlayerState

@onready var falling_state: State = $"../Falling"

func on_enter(previous_state: State, data := {}) -> void:
	if data.get(&'just_climbed', false):
		goto(previous_state)
	else:
		player.attack_finished.connect((func():
			goto(previous_state)
		), CONNECT_ONE_SHOT)

	player.attack(controller.get_aim_direction())

func on_physics_update(delta: float) -> void:
	super.on_physics_update(delta)

	if character.is_on_floor():
		character.move(0.0)
	else:
		character.move(0.0, falling_state.air_move_speed, falling_state.air_accel_speed, falling_state.air_decel_speed)
