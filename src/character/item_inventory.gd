class_name ItemInventory extends Node3D

@export var items: Dictionary[ItemResource, ItemObject]:
	get:
		var _dict: Dictionary[ItemResource, ItemObject] = {}
		for item in get_children():
			if item is ItemObject:
				_dict.set(item.resource, item)
		return _dict


func _ready() -> void:
	visible = false

func add_item(item: ItemObject) -> void:
	item.reparent(self)# items.append(item)

	print("ADDING ITEM " + item.resource.display_name)

	print.call_deferred(items)

	if item.resource.use_on_pickup:
		item.use(owner)
	else:
		Global.create_toast(item.resource.display_name + " acquired")

	await get_tree().create_timer(0.5).timeout
	print.call_deferred(items)

func add_item_resource(resource: ItemResource) -> void:
	add_item(ItemObject.new(resource))
