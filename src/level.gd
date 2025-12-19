@tool
class_name Level extends Node3D

var _default_map: PackedScene
@export var default_map: PackedScene:
	get:
		return _default_map
	set(value):
		_default_map = value
		if Engine.is_editor_hint():
			change_map(_default_map)

var current_map: Node3D = null

@export var player_prefab: PackedScene = preload("res://player.tscn")
@export var Flags: FlagsManager = FlagsManager.new()

@onready var hud_canvas := CanvasLayer.new()

var player_controller: PlayerController
var player: Player


func _enter_tree() -> void:
	Global.current_level = self

func _ready():
	change_map(default_map)


func init_level() -> void:
	if not player:
		player = player_prefab.instantiate()
		add_child.call_deferred(player)

	if not player_controller:
		player_controller = PlayerController.new(player)
		player_controller.name = &"PlayerController"

		add_child.call_deferred(player_controller)

	(func():
		var start_point := current_map.get_node(^"SPAWN_PLAYER") as Node3D
		player.global_position = start_point.global_position
		player.global_rotation = start_point.global_rotation
	).call_deferred()

	hud_canvas.name = &"HUDCanvasLayer"
	add_child(hud_canvas)

func change_map(new_map: PackedScene):
	print("Changing map to ", new_map)

	if current_map:
		current_map.queue_free()

	current_map = new_map.instantiate()
	add_child(current_map)

	init_level()
