extends Camera3D

@export var target: Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not target:
		target = owner.get_node(^"Player")

func _process(delta: float) -> void:
	if not target:
		return

	position = target.position + Vector3(0, 1, 3.5)
	# look_at(target.position)
