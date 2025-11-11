class_name PlayerJumpingState extends PlayerState

@onready var falling_state: State = $"../Falling"

func on_enter(_previous_state: State, data := {}) -> void:
	player.gravity_enabled = true
	player.move_enabled = true

	if not data.has(&'just_jumped'):
		data.set(&'just_jumped', true)

	if data.has(&"jump_force"):
		var force: Vector2 = data.get(&'jump_force')
		print("Found jump force of ", force)
		character.jump(force)
	else:
		character.jump()


	goto(falling_state, data)
