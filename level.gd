class_name Level extends Node3D

# @export var player_prefab: PackedScene = preload("res://player.tscn")
@export var player_controller: PlayerController

@onready var hud_canvas := CanvasLayer.new()


func _enter_tree() -> void:
	Global.current_level = self

func _ready() -> void:
	hud_canvas.name = &"HUDCanvasLayer"
	add_child(hud_canvas)
