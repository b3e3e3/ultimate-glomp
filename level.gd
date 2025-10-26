extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ECS.world = $World

	ECS.world.add_entity(Player.new($PlayerBody))
# Process systems by groups in order
func _process(delta):
	if ECS.world:
		ECS.world.process(delta)
