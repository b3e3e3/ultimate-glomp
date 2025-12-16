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
	if item.get_parent():
		item.reparent(self)
	else:
		add_child(item)

	print("ADDING ITEM " + item.resource.display_name)

	print.call_deferred(items)

	if item.resource.use_on_pickup:
		item.use(owner)
	else:
		Global.create_toast(item.resource.display_name + " acquired")

	await get_tree().create_timer(0.5).timeout
	print.call_deferred(items)

func add_item_resource(resource: ItemResource, character: Character = Global.current_level.player) -> void:
	var obj := preload("res://items/src/item_object.tscn").instantiate() as ItemObject

	obj.resource = resource
	obj.name = resource.display_name

	obj.pick_up(character)

func remove_item_object(item: ItemObject) -> void:
	if item in items.values():
		item.queue_free()
		items.erase(item.resource)

func remove_item(item_name: String) -> void:
	for i in items:
		if i.display_name == item_name:
			remove_item_object(items[i])
			return

func has_item(item_name: String) -> bool:
	for i in items:
		if i.display_name == item_name:
			return true
	return false

func has_item_resource(resource: ItemResource) -> bool:
	for i in items:
		if i.get_rid() == resource.get_rid():
			return true
	return false

func count_item(item_name: String) -> int:
	var count = 0
	for i in items:
		if i.display_name == item_name:
			count += 1
	return count

func count_item_resource(resource: ItemResource) -> int:
	return count_item(resource.display_name)
