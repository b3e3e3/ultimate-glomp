@tool
class_name Equipment extends Resource

@export var name: String = "Equipment"
@export_enum("Pants:0") var slot: int = 0

# @export var buffs: Array[Buff]
@export var adds: Dictionary[StringName, Variant] = {}
@export var multipliers: Dictionary[StringName, float] = {}


var buff_types: Dictionary[StringName, Variant.Type] = {
	&"jumps_after_climbing": TYPE_INT,
	&"speed": TYPE_FLOAT,
	&"decel_speed": TYPE_FLOAT,
	&"accel_speed": TYPE_FLOAT,
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

# func get_jumps_after_climbing(_owner: Character, _base_value: int) -> int: return 0
# func get_speed(_owner: Character, _base_value: float) -> float: return 0
# func get_decel_speed(_owner: Character, _base_value: float) -> float: return 0
# func get_accel_speed(_owner: Character, _base_value: float) -> float: return 0
# func get_jump_force(_owner: Character, _base_value: Vector3) -> Vector3: return Vector3.ZERO
# func get_wall_slide_speed(_owner: Character, _base_value: float) -> float: return 0
