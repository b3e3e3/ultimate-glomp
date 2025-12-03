class_name StatChangeItemAction extends ItemAction

@export var adds: Dictionary[StringName, Variant] = {}
@export var multipliers: Dictionary[StringName, float] = {}


func execute(character: Character):
	for a in adds:
		print("Giving %s some %s" % [character, a])

	for m in multipliers:
		print("Multiplying %s some %s" % [character, m])
