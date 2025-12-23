class_name PortalAction extends GameAction

@export_file_path("*.map") var level_path: String


func on_start(_character: Character, _owner: Node) -> void:
	Global.current_level.change_map(load(level_path))
	finish(true)
