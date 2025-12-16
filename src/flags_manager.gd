class_name FlagsManager extends Resource

signal flag_changed(flag_name: StringName, value: bool)

@export var flags: Dictionary[StringName, bool] = {}


func set_flag(flag_name: StringName, value: bool) -> void:
	print("Setting flag ", flag_name, " to ", value)
	flags.set(flag_name, value)
	flag_changed.emit(flag_name, value)

func get_flag(flag_name: StringName, default_value: bool = false) -> bool:
	return flags.get(flag_name, default_value)

func has_flag(flag_name: StringName) -> bool:
	return flags.has(flag_name)
