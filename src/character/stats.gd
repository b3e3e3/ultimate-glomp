@tool
class_name Stats extends Resource

# static var Types: Dictionary[StringName, Variant.Type] = {
# 	&"hp": TYPE_INT,

# 	&"speed": TYPE_FLOAT,
# 	&"decel_speed": TYPE_FLOAT,
# 	&"accel_speed": TYPE_FLOAT,

# 	&"air_speed": TYPE_FLOAT,
# 	&"air_decel_speed": TYPE_FLOAT,
# 	&"air_accel_speed": TYPE_FLOAT,

# 	&"jumps_after_climbing": TYPE_INT,
# 	&"jump_force": TYPE_VECTOR3,

# 	&"wall_slide_speed": TYPE_FLOAT,
# }

static func get_default_value(type: Variant.Type) -> Variant:
	match(type):
		TYPE_FLOAT:
			return 0.0
		TYPE_INT:
			return 0
		TYPE_VECTOR3:
			return Vector3.ZERO
		TYPE_VECTOR2:
			return Vector2.ZERO
	return 0

#############

@export var values: Dictionary[StringName, Variant] = {
	&"hp": 100,

	&"speed": 3.33,
	&"decel_speed": 50.0,
	&"accel_speed": 0.1,

	&"air_speed": 4.0,
	&"air_decel_speed": 50.0,
	&"air_accel_speed": 0.2,

	&"jumps_after_climbing": 0,
	&"jump_force": Vector3(0, 5.0, 0),

	&"wall_slide_speed": 1.0,
}

func get_value(key: StringName) -> Variant:
	return values.get(key, Stats.get_default_value(typeof(key)))

func set_value(key: StringName, value: Variant) -> void:
	values.set(key, value)
