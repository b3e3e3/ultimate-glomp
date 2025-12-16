class_name SetFlagsAction extends GameAction

@export var global_flags_to_set: Dictionary[StringName, bool] = {}
@export var level_flags_to_set: Dictionary[StringName, bool] = {}


func on_start(_character: Character = null) -> void:
	for k in global_flags_to_set:
		Global.Flags.set_flag(k, global_flags_to_set[k])
	for k in level_flags_to_set:
		Global.current_level.Flags.set_flag(k, level_flags_to_set[k])

	finish()
