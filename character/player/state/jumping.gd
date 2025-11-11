class_name PlayerJumpingState extends PlayerState

@onready var falling_state: State = $"../Falling"

@export var jump_force: float = Player.JUMP_VELOCITY

func on_enter(_previous_state: State, data := {}) -> void:
	player.gravity_enabled = true
	player.move_enabled = true
	data.set(&'just_jumped', true)

	var force := jump_force
	if data:
		if data.has(&"jump_force"):
			force = data[&"jump_force"]

	player.jump(force)
	goto(falling_state, data)
