class_name LedgeDetector extends Node3D

@export var ledge_offset: Vector3 = Vector3.UP * 1
@export var ledge_distance: float = 0.5

@onready var character: Character
@onready var periphery_cast: ShapeCast3D = $PeripheryCast
@onready var ledge_raycast: RayCast3D = $LedgeCast

var is_on_ledge: bool = false
var collision_point: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(owner is Character)
	character = owner as Character

func _physics_process(_delta: float) -> void:
	# periphery_cast.target_position = -character.last_direction

	is_on_ledge = false

	if periphery_cast.is_colliding():
		ledge_raycast.global_position = periphery_cast.get_collision_point(0) + ledge_offset
		if ledge_raycast.is_colliding():
			var point := ledge_raycast.get_collision_point()
			is_on_ledge = character.global_position.distance_to(point) < ledge_distance
			if is_on_ledge:
				collision_point = point

	$Marker.global_position = collision_point
