class_name FlagGuardAction extends GuardAction

@export var global_flags: Dictionary[StringName, bool]
@export var level_flags: Dictionary[StringName, bool]


func is_successful() -> bool:
	return _get_guard_result(Global.Flags) and _get_guard_result(Global.current_level.Flags)

func _get_guard_result(flags: FlagsManager):
	for key in global_flags:
		var val: bool = global_flags[key]

		if not flags.has_flag(key):
			return false

		if not flags.get_flag(key) == val:
			return false
	return true
