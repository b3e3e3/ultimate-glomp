class_name PlayerController extends Node

@export var character: CharacterBody2D

func _ready():
	if character == null:
		print("Controller found Player")
		character = get_node(^"../Player")

func get_horizontal_input() -> float:
	return Input.get_axis(&"move_left", &"move_right")

func get_jump_input() -> bool:
	return Input.is_action_just_pressed(&"jump")
