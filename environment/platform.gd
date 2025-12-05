@tool
class_name Platform extends StaticBody3D


@export var can_grab_ledge: bool = true

func _ready() -> void:
	set_collision_layer_value(8, true)
