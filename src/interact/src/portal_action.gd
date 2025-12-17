class_name PortalAction extends GameAction

@export_file_path("*.map") var level_path: String

func on_start(_character: Character = null) -> void:
	Global.current_level.load_map(level_path)
