@tool
class_name ComboPants extends Equipment

var combo_jump: ComboJump

var owner: Player = null


func _on_combo_added(_combo: int):
	adds.set(&"jump_force", combo_jump.get_jump_force())

func _on_combo_timer_expired(_combo: int):
	adds.set(&"jump_force", Vector3.ZERO)

func initialize(item_owner: Character) -> void:
	print("Initializing combo pants! Owner: ", item_owner.name)
	owner = item_owner

	combo_jump = ComboJump.new()
	combo_jump.name = &"ComboJump"

	owner.add_child.call_deferred(combo_jump)

	owner.get_node(^"StateMachine").state_changed.connect(_on_state_machine_state_changed) # TODO: direct reference! maybe don't assume the character has a state machine

	owner.glomped.connect(_on_player_glomped)
	combo_jump.combo_added.connect(_on_combo_added)
	combo_jump.timer_expired.connect(_on_combo_timer_expired)


func _on_player_glomped(_body: PhysicsBody3D) -> void:
	combo_jump.reset()

func _on_state_machine_state_changed(new_state: State, _previous_state: State) -> void:
	print(new_state.name)
	match new_state.name:
		&"Climbing":
			# reset combo jump and cancel flip.
			combo_jump.reset()
		&"Jumping":
			combo_jump.cancel_timer()
			if combo_jump.current_combo == 3:
				owner.get_node(^"Sprite").do_flip(owner.last_direction) # TODO: direct reference!
		&"Idle":
			combo_jump.progress()
			if new_state is PlayerState:
				if new_state.check_for_glomping():
					combo_jump.reset()
					combo_jump.cancel_timer()

				if _previous_state:
					if combo_jump.is_comboing():
						owner.get_node(^"ComboParticles").emitting = true # TODO: direct reference!
						owner.get_node(^"ComboParticles").amount_ratio = combo_jump.current_combo / 3.0
						owner.get_node(^"ComboParticles").process_mode = Node.PROCESS_MODE_ALWAYS
		&"Throwing":
			combo_jump.progress() # TODO: do we want this? progress combo jump when throwing the object
