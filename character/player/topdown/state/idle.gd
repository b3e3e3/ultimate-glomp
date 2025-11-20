class_name TDPlayerIdleState extends TDPlayerState

@onready var moving_state: TDPlayerState = $"../Moving"
@onready var interacting_state: PlayerState = $"../Interacting"


func on_update(_delta: float) -> void:
	if check_for_moving():
		goto(moving_state)
	elif check_for_interacting():
		goto(interacting_state)
