class_name InteractArea extends Area3D

signal started(interaction: GameAction)
signal finished(interaction: GameAction)
signal stepped(interaction: GameAction)


var _current_interaction: GameAction
var current_interaction: GameAction:
	get:
		return _current_interaction
	set(value):
		# disconnect existing signals
		if _current_interaction:
			print("Disconnecting current interaction")
			_current_interaction.started.disconnect(_on_interaction_started)
			_current_interaction.stepped.disconnect(_on_interaction_stepped)
			_current_interaction.finished.disconnect(_on_interaction_finished)

		# set the value
		_current_interaction = value

		# connect new signals if value is not null
		if _current_interaction:
			print("Connecting new current interaction")
			_current_interaction.started.connect(_on_interaction_started)
			_current_interaction.stepped.connect(_on_interaction_stepped)
			_current_interaction.finished.connect(_on_interaction_finished)



func find_and_start_interaction() -> void:
	# if Input.is_action_just_pressed(&"interact"):
	var areas := get_overlapping_areas()
	print("Looking for interactions... ",areas.size())

	for a in areas:
		if a.has_method(&"get_interaction"):
			current_interaction = a.get_interaction()
			current_interaction.start(owner, a.get_parent())
			break


# func start():
# 	if current_interaction: current_interaction.start()

func step():
	if current_interaction: current_interaction.step()

func finish():
	if current_interaction: current_interaction.finish()


func _on_interaction_started():
	started.emit(current_interaction)

func _on_interaction_stepped():
	stepped.emit(current_interaction)

func _on_interaction_finished(_success: bool):
	finished.emit(current_interaction)
	current_interaction = null


func _process(delta: float) -> void:
	if current_interaction:
		current_interaction.update(delta)
