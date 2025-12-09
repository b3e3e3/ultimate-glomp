class_name StatChangeGameAction extends GameAction

@export var adds: Dictionary[StringName, Variant] = {}
@export var multipliers: Dictionary[StringName, float] = {}


func execute(character: Character = null):
	for a in adds:
		print("Giving %s some %s" % [character, a])

	for m in multipliers:
		print("Multiplying %s some %s" % [character, m])
