@tool
class_name ItemObject extends RigidBody3D


signal thrown(by: Character)


@onready var sprite: Sprite3D = $Sprite3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

@export var resource: ItemResource



func _init(item_resource: ItemResource = null):
	initialize(item_resource)

func _func_godot_apply_properties(entity_properties: Dictionary):
	initialize(load("res://items/" + entity_properties["item_name"] + ".tres"))

func initialize(item_resource: ItemResource = null):
	if item_resource:
		resource = item_resource
		sprite.texture = resource.icon_texture

func _ready() -> void:
	if not Engine.is_editor_hint():
		sprite.texture = resource.icon_texture

	if resource.glompable:
		set_collision_layer_value(2, true)
	# sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	# add_child(sprite)


func get_thrown(by: Character):
	process_mode = PROCESS_MODE_INHERIT

	reparent(by.get_parent())
	collision_shape.reparent(self)

	pick_up(by)

	# delete self
	# queue_free()

	# emit thrown signal
	thrown.emit(by)

func get_glomped(by: Character):
	if not resource.glompable: return
	print("We getting glompppp")
	reparent(by)
	collision_shape.reparent(by)


func _on_pickup_area_body_entered(body: Node3D) -> void:
	print("Pick up?")
	if resource.pickup_on_touch and body is Character:
		print("Ye")
		use(body as Character)
	else:
		print(resource.pickup_on_touch)

func use(character: Character) -> void:
	print(resource.consume_on_use)
	if not resource.action: return
	resource.action.execute(character)
	if resource.consume_on_use:
		print("Consuming item")
		queue_free()

func pick_up(character: Character) -> void:
	print("ASJKNSDFKJKFJGN")
	freeze = true
	process_mode = PROCESS_MODE_DISABLED
	character.item_inventory.add_item(self)

# func _on_item_used() -> void:
# 	queue_free()
