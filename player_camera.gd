class_name PlayerCamera extends Camera3D

@export var target: Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not target:
		var children := owner.find_children("*", "Player")
		if children.size() > 0:
			target = children[0]

func _process(delta: float) -> void:
	if not target:
		return

	$Area3D.global_position = target.global_position

	if $Area3D.has_overlapping_areas():
		var areas = $Area3D.get_overlapping_areas()
		var area: Area3D = areas[0]

		global_position = position.move_toward(area.camera.global_transform.origin, delta * 5)
		global_rotation = global_rotation.move_toward(area.camera.global_rotation, delta * 1)
	else:
		global_position = position.lerp(target.position + Vector3(0, 1, 3.5), delta * 15)
		global_rotation = global_rotation.move_toward(Vector3.ZERO, delta * 1)
	# look_at(target.position)
