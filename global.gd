extends Node

@export var current_level: Level

func disable_collision(node: Node):
	if node is CollisionShape2D:
		node.set_deferred(&"disabled", true)
		return

	var children := node.find_children("*", "CollisionShape2D")
	for child in children:
		child.set_deferred(&"disabled", true)

func enable_collision(node: Node):
	if node is CollisionShape2D:
		node.set_deferred(&"disabled", false)
		return

	var children := node.find_children("*", "CollisionShape2D")
	for child in children:
		child.set_deferred(&"disabled", false)
