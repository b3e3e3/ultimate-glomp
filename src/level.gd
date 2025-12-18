@tool
class_name Level extends Node3D

@export var player_prefab: PackedScene = preload("res://player.tscn")

@onready var hud_canvas := CanvasLayer.new()

@export var player: Player
@export var player_controller: PlayerController

@export var Flags: FlagsManager = FlagsManager.new()


func _enter_tree() -> void:
	Global.current_level = self
	if not player:
		player = player_prefab.instantiate()

		add_child(player)
	if not player_controller:
		player_controller = PlayerController.new(player)
		player_controller.name = &"PlayerController"

		add_child(player_controller)


func _ready() -> void:
	hud_canvas.name = &"HUDCanvasLayer"
	add_child(hud_canvas)

# func _func_godot_build_complete() -> void:
	var start_point := $FuncGodotMap.get_node(^"SPAWN_PLAYER")

	player.global_position = start_point.global_position
	player.global_rotation = start_point.global_rotation

# 	var map := preload("res://default_map.tscn").instantiate() as FuncGodotMap
# 	map.local_map_file = path

# 	add_child(map)
# 	map.name = "FuncGodotMap"

# 	map.build()
