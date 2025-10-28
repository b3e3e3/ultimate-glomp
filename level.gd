extends Node2D

@export var player_prefab: PackedScene = preload("res://player.tscn")
@export var world: World

func _ready() -> void:
	if world:
		ECS.world = world
	else:
		ECS.world = $World

	for e in ECS.world.entities:
		ECS.world.enable_entity(e)

	# var player := player_prefab.instantiate() as Player
	# get_tree().current_scene.add_child(player)
	# ECS.world.add_entity(player)
# Process systems by groups in order
func _process(delta):
	if ECS.world:
		ECS.world.process(delta)
