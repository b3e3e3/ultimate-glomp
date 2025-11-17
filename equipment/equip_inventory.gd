class_name EquipInventory extends Node

@export var equipment: Array[Equipment] = []


func _ready() -> void:
	for e in equipment:
		e.initialize(owner)

func equip(item: Equipment) -> void:
	item.initialize(owner)
	# item.equip()

func get_all_adds(key: StringName) -> Variant:
	var default: Variant = Equipment.get_default(Equipment.BuffTypes[key])
	var val: Variant = default

	for e in equipment:
		val += e.adds.get(key, default)

	return val

func get_all_multipliers(key: StringName) -> Variant:
	var val: Variant = 1.0

	for e in equipment:
		val *= e.multipliers.get(key, 1.0)

	return val
