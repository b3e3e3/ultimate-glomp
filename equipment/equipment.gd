@tool
class_name Equipment extends Resource


@export var name: String = "Equipment"
@export_enum("Pants:0") var slot: int = 0

@export var adds: Dictionary[StringName, Variant] = {}
@export var multipliers: Dictionary[StringName, float] = {}


static var BuffTypes: Dictionary[StringName, Variant.Type] = {
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


static func get_default(type: Variant.Type) -> Variant:
	match(type):
		TYPE_FLOAT:
			return 0.0
		TYPE_VECTOR3:
			return Vector3.ZERO
		TYPE_VECTOR2:
			return Vector2.ZERO
	return 0

func _init() -> void:
	for buff_name in BuffTypes:
		if not adds.has(buff_name):
			adds[buff_name] = get_default(BuffTypes[buff_name])
		if not multipliers.has(buff_name):
			multipliers[buff_name] = 1.0

func initialize(_owner: Character) -> void: pass
