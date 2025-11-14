class_name PlayerController extends Node

@export var character: Character

@onready var camera: Camera3D = $"../Camera3D"


func _ready():
	if character == null:
		push_warning("Controller character is null, finding Player")
		character = get_node(^"../Player")

func control_direction():
	var hor := get_horizontal_input()
	# character.direction.x = hor if hor != 0 else character.direction.x
	character.direction.x = hor

func get_horizontal_input() -> float:
	return Input.get_axis(&"move_left", &"move_right")

func get_vertical_input() -> float:
	return Input.get_axis(&"move_down", &"move_up")

func just_pressed_horizontal():
	return Input.is_action_just_pressed(&"move_left") || Input.is_action_just_pressed(&"move_right")

func just_pressed_vertical():
	return Input.is_action_just_pressed(&"move_up") || Input.is_action_just_pressed(&"move_down")


func get_jump_input() -> bool:
	return Input.is_action_just_pressed(&"jump")

func get_attack_input() -> bool:
	return Input.is_action_just_pressed(&"attack")

func get_aim_direction() -> Vector3:
	# return Vector3.RIGHT # TODO
	var v := character.global_position.direction_to(get_mouse_position())

	return v

func get_mouse_position() -> Vector3:
	var mpos := get_viewport().get_mouse_position()
	var origin := camera.project_ray_origin(mpos)
	var direction := camera.project_ray_normal(mpos)

	if direction.y == 0.0:
		return Vector3.ZERO

	var distance := -origin.z / direction.z
	var xz_pos := origin + direction * distance

	return Vector3(xz_pos.x, xz_pos.y, 0.0)
