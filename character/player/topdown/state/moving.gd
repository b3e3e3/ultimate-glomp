class_name TDPlayerMovingState extends TDPlayerState

@onready var idle_state: State = $"../Idle"
@onready var interacting_state: State = $"../Interacting"

var movement: Vector2


func on_update(_delta: float) -> void:
	if check_for_interacting():
		goto(interacting_state)

func on_physics_update(delta: float) -> void:
	super.on_physics_update(delta)

	movement = controller.get_multi_input()

	if check_for_moving():
		player.move_multi(movement)
	else:
		goto(idle_state)
