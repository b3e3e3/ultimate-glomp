class_name TDPlayerIdleState extends TDPlayerState

@onready var moving_state: State = $"../Moving"
@onready var interacting_state: State = $"../Interacting"


func on_physics_update(_delta: float) -> void:
	if check_for_moving():
		goto(moving_state)

func on_update(_delta: float) -> void:
	if check_for_interacting():
		goto(interacting_state)
