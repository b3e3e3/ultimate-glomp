extends Node2D

@export var player_prefab: PackedScene = preload("res://player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ECS.world = $World

	var player := player_prefab.instantiate() as Player
	get_tree().current_scene.add_child(player)
	ECS.world.add_entity(player)
# Process systems by groups in order
func _process(delta):
	if ECS.world:
		ECS.world.process(delta)
