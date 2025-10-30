class_name PlayerIdleState extends PlayerState

@onready var moving_state: State = $"../Moving"
@onready var falling_state: State = $"../Falling"
@onready var jumping_state: State = $"../Jumping"
@onready var glomping_state: State = $"../Glomping"

func on_physics_update(delta: float) -> void:
	player.apply_gravity(delta)

	if check_for_moving():
		goto(moving_state)
	elif check_for_falling():
		goto(falling_state)
	elif check_for_glomping():
		goto(glomping_state)
	elif check_for_jumping():
		goto(jumping_state)
