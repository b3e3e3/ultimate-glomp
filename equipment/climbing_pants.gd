class_name ClimbingPantsEquipment extends Equipment


func get_jumps_after_climbing(_owner: Character, _base_value: int) -> int:
	return 1

func get_wall_slide_speed(_owner: Character, _base_value: float) -> float:
	return -_base_value
