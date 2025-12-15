class_name PlayerJumpingState extends PlayerState

@onready var falling_state: State = $"../Falling"

func on_enter(_previous_state: State, data := {}) -> void:
	player.gravity_enabled = true
	player.move_enabled = true

	data.set(&'just_jumped', true)

	var force: Vector3 = data.get(&'jump_force', character.get_jump_force())
	# print("FWORCE: ",force)

	character.jump(force)

	# goto(falling_state, data)
	goto(falling_state, data)
