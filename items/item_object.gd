@tool
class_name ItemObject extends RigidBody3D


signal thrown(by: Character)


@onready var sprite: Sprite3D = $Sprite3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

@export var item_resource: ItemResource


func _func_godot_apply_properties(entity_properties: Dictionary):
	item_resource = load("res://items/" + entity_properties["item_name"] + ".tres")
	sprite.texture = item_resource.icon_texture

func _ready() -> void:
	if not Engine.is_editor_hint():
		sprite.texture = item_resource.icon_texture

	if item_resource.glompable:
		set_collision_layer_value(2, true)

	item_resource.used.connect(_on_item_used)
	# sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	# add_child(sprite)


func get_thrown(by: Character):
	process_mode = PROCESS_MODE_INHERIT

	reparent(by.get_parent())
	collision_shape.reparent(self)

	item_resource.pick_up(by)

	# delete self and emit thrown signal
	queue_free()
	thrown.emit(by)

func get_glomped(by: Character):
	if not item_resource.glompable: return
	reparent(by)
	collision_shape.reparent(by)
	process_mode = PROCESS_MODE_DISABLED


func _on_pickup_area_body_entered(body: Node3D) -> void:
	print("GUH")
	if item_resource.use_on_touch and body is Character:
		item_resource.use(body as Character)

func _on_item_used() -> void:
	queue_free()
