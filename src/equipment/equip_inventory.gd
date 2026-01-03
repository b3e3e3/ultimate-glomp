class_name EquipInventory extends Node

@export var equipment: Array[Equipment] = []


func _ready() -> void:
	for e in equipment:
		e.initialize(owner)

func equip(item: Equipment) -> void:
	item.initialize(owner)
	# item.equip()

func get_all_adds(key: StringName) -> Variant:
	var c := owner as Character
	var val: Variant = Stats.get_default_value(typeof(c.stats.get_value(key)))

	for e in equipment:
		var a = e.adds.get(key)
		if not a: continue

		val += a

	return val

func get_all_multipliers(key: StringName) -> Variant:
	var val: Variant = 1.0

	for e in equipment:
		val *= e.multipliers.get(key, 1.0)

	return val
