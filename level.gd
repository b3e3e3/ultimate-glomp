@tool
class_name Level extends Node3D

@export var player_prefab: PackedScene = preload("res://player.tscn")

@onready var hud_canvas := CanvasLayer.new()

var player: Player
var player_controller: PlayerController

func _enter_tree() -> void:
	Global.current_level = self


func _ready() -> void:
	var start_point := get_node(^"FuncGodotMap/SPAWN_PLAYER")

	player = player_prefab.instantiate()
	player_controller = PlayerController.new(player)
	player_controller.name = &"PlayerController"

	add_child(player)
	add_child(player_controller)

	if start_point:
		player.position = start_point.position
		player.rotation = start_point.rotation

	hud_canvas.name = &"HUDCanvasLayer"
	add_child(hud_canvas)


func _on_func_godot_map_build_complete() -> void:
	pass # var map := $FuncGodotMap as FuncGodotMap
	# for child in map.get_children():
