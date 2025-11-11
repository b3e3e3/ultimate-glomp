class_name PlayerController extends Node

@export var character: Character

func _ready():
	if character == null:
		print("Controller found Player")
		character = get_node(^"../Player")

func control_direction():
	var hor := get_horizontal_input()
	character.direction.x = hor if hor != 0 else character.direction.x

func get_horizontal_input() -> float:
	return Input.get_axis(&"move_left", &"move_right")

func get_vertical_input() -> float:
	return Input.get_axis(&"move_up", &"move_down")

func get_jump_input() -> bool:
	return Input.is_action_just_pressed(&"jump")

func just_pressed_horizontal():
	return Input.is_action_just_pressed(&"move_left") || Input.is_action_just_pressed(&"move_right")

func just_pressed_vertical():
	return Input.is_action_just_pressed(&"move_up") || Input.is_action_just_pressed(&"move_down")
