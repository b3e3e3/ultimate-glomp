extends Node

@export var current_level: Level

@onready var tree := self.get_tree()


func create_timer(time_sec: float, process_always: bool = true, process_in_physics: bool = false, ignore_time_scale: bool = false):
	return tree.create_timer(time_sec, process_always, process_in_physics, ignore_time_scale)
