class_name LedgeGrabState extends PlayerState

@onready var jump_state: State = $"../Jumping"
@onready var falling_state: State = $"../Falling"


func on_enter(previous_state: State, data := {}) -> void:
	character.velocity = Vector3.ZERO
	character.global_position = ledge_detector.collision_point

	character.move_enabled = false
	character.gravity_enabled = false


func on_physics_update(_delta: float) -> void:
	if check_for_jumping():
		goto(jump_state)
	elif check_for_moving_vertical():
		var ver := controller.get_vertical_input()
		if ver < 0:
			goto(falling_state)
