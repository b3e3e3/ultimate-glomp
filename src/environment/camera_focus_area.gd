extends Area3D

@onready var camera: Camera3D = Camera3D.new()

@export var camera_pos: Vector3
@export var camera_rot: Vector3


func _ready() -> void:
	add_child(camera)

func _process(_delta):
	camera.position = camera_pos
	camera.rotation_degrees = camera_rot


func _on_interact_area_finished(_interaction: Interaction, success: bool) -> void:
	if success: queue_free()
