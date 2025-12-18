class_name PlayerJumpingState extends PlayerState

@onready var falling_state: State = $"../Falling"
@onready var glomping_state: State = $"../Glomping"

func on_enter(_previous_state: State, data := {}) -> void:
	# dont let us buffer a jump when glomping something!
	if check_for_glomping() and not player.glomped_body:
		goto(glomping_state, data)
		return

	player.gravity_enabled = true
	player.move_enabled = true

	data.set(&'just_jumped', true)

	var force: Vector3 = data.get(&'jump_force', character.get_jump_force())
	# print("FWORCE: ",force)

	character.jump(force)

	# goto(falling_state, data)
	goto(falling_state, data)
