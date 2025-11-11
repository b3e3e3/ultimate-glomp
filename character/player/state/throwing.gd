class_name PlayerThrowingState extends PlayerState

@onready var idle_state: State = $"../Idle"
@onready var glomping_state: State = $"../Glomping"
@onready var jump_state: State = $"../Jumping"

func on_enter(_previous_state: State, _data := {}) -> void:
	if not player.glomped_body \
	or not player.glomped_body.is_in_group(&"Throwable"):
		goto(idle_state)

	player.process_mode = PROCESS_MODE_DISABLED
	player.glomped_body.call(&"get_thrown", player)

	await get_tree().create_timer(1.0).timeout
	goto(jump_state)

func on_exit() -> void:
	player.process_mode = PROCESS_MODE_INHERIT
