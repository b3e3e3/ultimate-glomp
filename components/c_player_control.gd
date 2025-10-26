class_name  C_PlayerControl
extends Component

func get_move_axis() -> float:
	return Input.get_axis(&"move_left", &"move_right")

func get_jump_axis() -> bool:
	return Input.is_action_pressed(&"jump")
