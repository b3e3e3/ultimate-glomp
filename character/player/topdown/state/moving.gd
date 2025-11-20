class_name TDPlayerMovingState extends TDPlayerState

@onready var idle_state: TDPlayerState = $"../Idle"
@onready var interacting_state: PlayerState = $"../Interacting"

var movement: Vector2


func on_physics_update(_delta: float) -> void:
	movement = controller.get_multi_input()

	if check_for_moving():
		player.move_multi(movement)
	elif check_for_interacting():
		goto(interacting_state)
	else:
		goto(idle_state)
