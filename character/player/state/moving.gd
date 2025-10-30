class_name PlayerMovingState extends PlayerState

@onready var idle_state: State = $"../Idle"
@onready var falling_state: State = $"../Falling"
@onready var jumping_state: State = $"../Jumping"
@onready var glomping_state: State = $"../Glomping"

var movement: float = 0.0

func on_physics_update(delta: float) -> void:
	player.apply_gravity(delta)

	movement = player.get_horizontal_input()

	if check_for_falling():
		goto(falling_state)
	elif check_for_jumping():
		goto(jumping_state)
	elif check_for_moving():
		player.move(movement)
	elif check_for_glomping():
		goto(glomping_state)
	else:
		goto(idle_state)
