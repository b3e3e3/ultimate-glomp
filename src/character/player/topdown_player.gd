class_name TDPlayer extends Player

# hooks
func _ready() -> void:
	gravity_enabled = false


# override
func get_stat_with_buffs(_key: StringName, value: Variant):
	return value
