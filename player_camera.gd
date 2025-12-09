class_name PlayerCamera extends Camera3D

@export var target: Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not target:
		target = owner.get_node(^"Player")

func _process(delta: float) -> void:
	if not target:
		return

	var targ_pos := target.position + Vector3(0, 1, 3.5)
	var targ_rot := Vector3.ZERO

	$Area3D.global_position = target.global_position
	if $Area3D.has_overlapping_areas():
		var areas = $Area3D.get_overlapping_areas()
		var area: Area3D = areas[0]
		targ_pos = area.camera.global_transform.origin
		targ_rot = area.camera.global_rotation

	global_position = position.move_toward(targ_pos, delta * 5)
	global_rotation = global_rotation.move_toward(targ_rot, delta * 1)
	# look_at(target.position)
