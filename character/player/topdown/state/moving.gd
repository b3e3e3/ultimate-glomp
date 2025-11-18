class_name TDPlayerMovingState extends TDPlayerState

@onready var idle_state: TDPlayerState = $"../Idle"

var movement: Vector2


func on_physics_update(_delta: float) -> void:
	movement = controller.get_multi_input()

	if check_for_moving():
		player.move_multi(movement)
	else:
		goto(idle_state)
