class_name ItemInventory extends Node


@export var items: Array[ItemResource]

func add_item(item: ItemResource) -> void:
	items.append(item)
	Global.create_toast(item.display_name + " acquired")
