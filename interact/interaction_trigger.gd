class_name InteractionTrigger extends Node3D

signal started(interaction: Interaction)
signal stepped(interaction: Interaction)
signal finished(interaction: Interaction)
signal updated(interaction: Interaction)

@export var interaction: Interaction


func get_interaction() -> Interaction:
	return interaction


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

func _on_interaction_finished():
	finished.emit(interaction)

func _on_interaction_updated():
	updated.emit(interaction)


# func interact(_with: InteractArea) -> Interaction:
# 	interaction.start()
# 	return interaction
