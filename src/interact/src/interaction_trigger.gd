class_name InteractionTrigger extends Node3D

signal started(interaction: GameAction)
signal stepped(interaction: GameAction)
signal finished(interaction: GameAction, success: bool)
signal updated(interaction: GameAction)

var _interaction: GameAction
@export var interaction: GameAction:
	get:
		return _interaction
	set(val):
		_interaction = val
		_update_interaction_signals()


func get_interaction() -> GameAction:
	return interaction

func start_interaction() -> void:
	interaction.start(Global.current_level.player, owner) # TODO: WHICH CHARACTER?!?!?!

func _update_interaction_signals():
	if not interaction: return

	if interaction.started.is_connected(_on_interaction_started):
		interaction.started.disconnect(_on_interaction_started)

	if interaction.stepped.is_connected(_on_interaction_stepped):
		interaction.stepped.disconnect(_on_interaction_stepped)

	if interaction.finished.is_connected(_on_interaction_finished):
		interaction.finished.disconnect(_on_interaction_finished)

	if interaction.updated.is_connected(_on_interaction_updated):
		interaction.updated.disconnect(_on_interaction_updated)

	interaction.started.connect(_on_interaction_started)
	interaction.stepped.connect(_on_interaction_stepped)
	interaction.finished.connect(_on_interaction_finished)
	interaction.updated.connect(_on_interaction_updated)

func _ready() -> void:
	_update_interaction_signals()

func _exit_tree() -> void:
	if not interaction: return

	interaction.started.disconnect(_on_interaction_started)
	interaction.stepped.disconnect(_on_interaction_stepped)
	interaction.finished.disconnect(_on_interaction_finished)
	interaction.updated.disconnect(_on_interaction_updated)


func _on_interaction_started():
	started.emit(interaction)

func _on_interaction_stepped():
	stepped.emit(interaction)

func _on_interaction_finished(success: bool):
	finished.emit(interaction, success)

func _on_interaction_updated():
	updated.emit(interaction)


# func interact(_with: InteractArea) -> GameAction:
# 	interaction.start()
# 	return interaction
