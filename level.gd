class_name Level extends Node3D

# @export var player_prefab: PackedScene = preload("res://player.tscn")
@export var player_controller: PlayerController

func _enter_tree() -> void:
	Global.current_level = self
