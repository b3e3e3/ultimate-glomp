class_name FlagGuardAction extends GuardAction

@export var global_flags: Dictionary[StringName, bool]
@export var level_flags: Dictionary[StringName, bool]


func is_successful() -> bool:
	var has_global: bool = global_flags.size() == 0 or _get_guard_result(Global.Flags)
	var has_level: bool = level_flags.size() == 0 or _get_guard_result(Global.current_level.Flags)

	return has_global and has_level

func _get_guard_result(flags: FlagsManager):
	print("For flags in ", flags.flags)

	var i: int = 0
	var size := flags.flags.size()

	for key in flags.flags:
		var val: bool = flags.get_flag(key)

		print("Has flag %s? %s" % [key, flags.has_flag(key)])
		print("Flag %s value? %s" % [key, flags.get_flag(key)])
		if flags.has_flag(key) and flags.get_flag(key) == val:
			i += 1

	return i == size and size > 0
