class_name StatChangeGameAction extends GameAction

@export var adds: Dictionary[StringName, Variant] = {}
@export var multipliers: Dictionary[StringName, float] = {}
@export var character_path: NodePath


# func execute(character: Character = null):
func on_start(character: Character = null) -> void:
	for a in adds:
		print("Giving %s some %s" % [character, a])

	for m in multipliers:
		print("Multiplying %s some %s" % [character, m])

	finish()
