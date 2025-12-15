class_name PlayerThrowingState extends PlayerState

# @onready var idle_state: State = $"../Idle"
@onready var falling_state: State = $"../Falling"
@onready var glomping_state: State = $"../Glomping"
@onready var jump_state: State = $"../Jumping"

func on_enter(_previous_state: State, _data := {}) -> void:
	if not player.glomped_body:
		goto(falling_state)

	player.get_node(^"Sprite").do_flip(player.last_direction) # TODO: direct reference!

	var is_auto_throw := player.glomped_body.has_meta(&"auto_throw")

	player.process_mode = PROCESS_MODE_DISABLED
	player.glomped_body.call(&"get_thrown", player)

	player.un_glomp()

	print("Get thrownnnn")

	await Global.create_timer(0.4).timeout
	if is_auto_throw:
		goto(falling_state)
	else:
		goto(jump_state)

func on_exit() -> void:
	player.process_mode = PROCESS_MODE_INHERIT
