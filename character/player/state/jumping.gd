class_name PlayerJumpingState extends PlayerState

@onready var falling_state: State = $"../Falling"

func on_enter(_previous_state: State, data := {}) -> void:
	player.gravity_enabled = true
	player.move_enabled = true

	if not data.has(&'just_jumped'):
		data.set(&'just_jumped', true)

	var combo_force := (character.get_jump_force() / 3) * (max(0, player.combo_jump.current_combo - 1) as int)
	var force: Vector3 = data.get(&'jump_force', character.get_jump_force() + combo_force)

	character.jump(force)

	player.combo_jump.cancel_timer()

	goto(falling_state, data)
