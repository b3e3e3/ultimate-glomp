class_name Equipment extends Resource

@export var name: String = "Equipment"
@export_enum("Pants:0") var slot: int = 0

func get_jumps_after_climbing(_owner: Character, _base_value: int) -> int: return 0
func get_speed(_owner: Character, _base_value: float) -> float: return 0
func get_decel_speed(_owner: Character, _base_value: float) -> float: return 0
func get_accel_speed(_owner: Character, _base_value: float) -> float: return 0
func get_jump_force(_owner: Character, _base_value: Vector3) -> Vector3: return Vector3.ZERO
func get_wall_slide_speed(_owner: Character, _base_value: float) -> float: return 0
