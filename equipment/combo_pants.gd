@tool
class_name ComboPants extends Equipment

@export var additional_force: Vector3 = Vector3.UP * 4.0
@export var cooldown_time: float = 0.1
@export var combo_limit: int = 3

var current_combo: int = -1

var timer: Timer = Timer.new()


func _on_combo_timer_expired(_combo: int):
	adds.set(&"jump_force", Vector3.ZERO)

func initialize(item_owner: Character) -> void:
	await super.initialize(item_owner)
	print("Initializing combo pants! Owner: ", item_owner.name)

	owner.add_child(timer)
	timer.timeout.connect(_on_timeout)

	owner.state_machine.state_changed.connect(_on_state_machine_state_changed) # TODO: direct reference! maybe don't assume the character has a state machine

	owner.glomped.connect(_on_player_glomped)


func _on_player_glomped(_body: PhysicsBody3D) -> void:
	reset()

func _on_state_machine_state_changed(new_state: State, _previous_state: State) -> void:
	print(new_state.name)
	match new_state.name:
		&"Climbing":
			# reset combo jump and cancel flip.
			reset()
		&"Jumping":
			cancel_timer()
			if current_combo == 3:
				owner.get_node(^"Sprite").do_flip(owner.last_direction) # TODO: direct reference!
		&"Idle":
			progress()
			if new_state is PlayerState:
				if new_state.check_for_glomping():
					reset()
					cancel_timer()

				if _previous_state:
					if is_comboing():
						owner.get_node(^"ComboParticles").emitting = true # TODO: direct reference!
						owner.get_node(^"ComboParticles").amount_ratio = current_combo / 3.0
						owner.get_node(^"ComboParticles").process_mode = Node.PROCESS_MODE_ALWAYS
		&"Throwing":
			progress() # TODO: do we want this? progress combo jump when throwing the object




func combo_limit_reached() -> bool:
	return current_combo >= combo_limit

func reset():
	current_combo = -1

func cancel_timer():
	timer.stop()

func progress() -> bool:
	timer.start(cooldown_time)

	if combo_limit_reached():
		reset()
	else:
		current_combo += 1
		print("COMBO ADDED!")

	print("Combo added! ", current_combo)
	print("Force: ", get_jump_force())
	adds.set(&"jump_force", get_jump_force())

	return not combo_limit_reached()


func is_comboing() -> bool:
	return current_combo > 0

func _on_timeout():
	cancel_timer()
	reset()

	adds.set(&"jump_force", Vector3.ZERO)

func get_jump_force() -> Vector3:
	return (additional_force / combo_limit) * (max(0, current_combo - 1) as int)

func debug_text() -> String:
	return "Jump combo: " + str(current_combo) + " / " + str(combo_limit)
