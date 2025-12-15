class_name ItemGuardAction extends GuardAction

@export var items: Array[ItemResource]


func is_successful() -> bool:
	var inventory := Global.current_level.player.item_inventory

	for item in items:
		if not inventory.items.has(item):
			return false

	return true
