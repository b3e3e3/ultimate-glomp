class_name LedgeDetector extends Node3D

@export var disabled: bool = false

@export var ledge_offset: Vector3 = Vector3.UP * 1
@export var ledge_distance: float = 0.5

@onready var character: Character
@onready var periphery_cast: ShapeCast3D = $PeripheryCast
@onready var ledge_cast: RayCast3D = $LedgeCast

var is_on_ledge: bool = false
var _last_collision_point: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(owner is Character)
	character = owner as Character

func get_collision_point() -> Vector3:
	if periphery_cast.is_colliding():
		ledge_cast.global_position = periphery_cast.get_collision_point(0) + ledge_offset
		if ledge_cast.is_colliding():
			var point := ledge_cast.get_collision_point()
			point = Vector3(point.x, point.y, character.global_position.z)
			is_on_ledge = character.global_position.distance_to(point) < ledge_distance
			if is_on_ledge:
				_last_collision_point = point
				return point

	return _last_collision_point

func _physics_process(_delta: float) -> void:
	is_on_ledge = false

	periphery_cast.enabled = not disabled
	ledge_cast.enabled = not disabled

	get_collision_point()

	$Marker.global_position = _last_collision_point
