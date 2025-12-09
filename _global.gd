extends Node

const toast_scene: PackedScene = preload("res://ui/toast.tscn")
const message_box_scene: PackedScene = preload("res://ui/message_box.tscn")

@export var current_level: Level

@onready var tree := self.get_tree()


func create_timer(time_sec: float, process_always: bool = true, process_in_physics: bool = false, ignore_time_scale: bool = false):
	return tree.create_timer(time_sec, process_always, process_in_physics, ignore_time_scale)

func create_toast(message: String, duration: float = 3.0):
	var toast := toast_scene.instantiate()
	self.current_level.hud_canvas.add_child(toast)
	toast.display(message, duration)

func create_message_box(position: Vector2, box_scene: PackedScene = message_box_scene) -> MessageBox:
	var message_box := box_scene.instantiate()

	self.current_level.hud_canvas.add_child(message_box)
	message_box.position = position
	message_box.position.y -= 160

	return message_box

func pos2screen(position: Vector3) -> Vector2:
	var cam := get_viewport().get_camera_3d()
	return cam.unproject_position(position)
