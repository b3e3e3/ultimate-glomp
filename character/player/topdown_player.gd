class_name TDPlayer extends Player


func _ready() -> void:
	# super._ready()
	gravity_enabled = false

# override
func get_stat_with_buffs(_key: StringName, value: Variant):
	return value
