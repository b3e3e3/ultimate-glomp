class_name TDPlayerIdleState extends TDPlayerState

@onready var moving_state: TDPlayerState = $"../Moving"


func on_physics_update(_delta: float) -> void:
	if check_for_moving():
		print("Moing?")
		goto(moving_state)
