class_name StatChangeGameAction extends GameAction

@export var adds: Dictionary[StringName, Variant] = {}
@export var multipliers: Dictionary[StringName, float] = {}
@export var character_path: NodePath


# func execute(character: Character = null):
func on_start(character: Character, _owner: Node) -> void:
	for a in adds:
		print("Giving %s %s %s" % [character.name, adds[a], a])
		var val = character.get_stat_with_buffs(a) + adds[a]
		character.set_stat(a, val)

	for m in multipliers:
		print("Giving %s %s %s" % [character.name, multipliers[m], m])
		var val = character.get_stat_with_buffs(m) * multipliers[m]
		character.set_stat(m, val)

	finish()
