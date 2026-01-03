@tool
class_name Equipment extends Resource


@export var name: String = "Equipment"
@export_enum("Pants:0") var slot: int = 0

@export var adds: Dictionary[StringName, Variant] = {}
@export var multipliers: Dictionary[StringName, float] = {}

var owner: Character = null


# func _init() -> void:
# 	for buff_name in Stats.Types:
# 		if not adds.has(buff_name):
# 			adds[buff_name] = 0#Stats.get_default_value(Stats.Types[buff_name])
# 		if not multipliers.has(buff_name):
# 			multipliers[buff_name] = 1.0

func initialize(item_owner: Character) -> void:
	self.owner = item_owner
	if not self.owner.is_node_ready():
		await self.owner.ready

func debug_text() -> String: return ""
