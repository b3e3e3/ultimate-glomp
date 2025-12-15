class_name InteractionTrigger extends Node3D

signal started(interaction: GameAction)
signal stepped(interaction: GameAction)
signal finished(interaction: GameAction, success: bool)
signal updated(interaction: GameAction)

@export var interaction: GameAction


func get_interaction() -> GameAction:
	return interaction

func start_interaction() -> void:
	interaction.start(Global.current_level.player) # TODO: WHICH CHARACTER?!?!?!

func _ready() -> void:
	interaction.started.connect(_on_interaction_started)
	interaction.stepped.connect(_on_interaction_stepped)
	interaction.finished.connect(_on_interaction_finished)
	interaction.updated.connect(_on_interaction_updated)

func _exit_tree() -> void:
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
