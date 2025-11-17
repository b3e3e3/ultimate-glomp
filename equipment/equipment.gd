@tool
class_name Equipment extends Resource

@export var name: String = "Equipment"
@export_enum("Pants:0") var slot: int = 0

@export var adds: Dictionary[StringName, Variant] = {}
@export var multipliers: Dictionary[StringName, float] = {}


var buff_types: Dictionary[StringName, Variant.Type] = {
	&"speed": TYPE_FLOAT,
	&"decel_speed": TYPE_FLOAT,
	&"accel_speed": TYPE_FLOAT,

	&"air_speed": TYPE_FLOAT,
	&"air_decel_speed": TYPE_FLOAT,
	&"air_accel_speed": TYPE_FLOAT,

	&"jumps_after_climbing": TYPE_INT,
	&"jump_force": TYPE_VECTOR3,

	&"wall_slide_speed": TYPE_FLOAT,
}

func _init() -> void:
	for buff_name in buff_types:
		if not adds.has(buff_name):
			match(buff_types[buff_name]):
				TYPE_FLOAT:
					adds[buff_name] = 0.0
				TYPE_VECTOR3:
					adds[buff_name] = Vector3.ZERO
				TYPE_VECTOR2:
					adds[buff_name] = Vector2.ZERO
				_:
					adds[buff_name] = 0
		if not multipliers.has(buff_name):
			multipliers[buff_name] = 1.0
