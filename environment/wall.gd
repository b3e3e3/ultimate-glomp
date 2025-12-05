@tool
class_name Wall extends StaticBody3D


@export var is_slideable: bool = true
@export var is_climbable: bool = true
@export var is_swappable: bool = false


func _ready():
	if is_slideable:
		add_to_group(&"Slideable") # TODO: maybe move away from groups?

	if is_climbable:
		add_to_group(&"Climbable") # TODO: maybe move away from groups?
	set_collision_layer_value(5, is_climbable) # TODO: constant!!

	if is_swappable:
		add_to_group(&"Swappable") # TODO: maybe move away from groups?

# func _func_godot_apply_properties(entity_properties: Dictionary):
# 	for key in entity_properties:
# 		var value = entity_properties[key]
# 		set(key, value)
