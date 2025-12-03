@tool
class_name ItemObject extends RigidBody3D


signal thrown(by: Character)


@onready var sprite: Sprite3D = Sprite3D.new()
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

@export var item_resource: ItemResource


func _ready() -> void:
	sprite.texture = item_resource.icon_texture
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(sprite)

func get_thrown(by: Character):
	process_mode = PROCESS_MODE_INHERIT

	reparent(by.get_parent())
	collision_shape.reparent(self)

	# delete self and emit thrown signal
	queue_free()
	thrown.emit(by)

func get_glomped(by: Character):
	reparent(by)
	collision_shape.reparent(by)
	process_mode = PROCESS_MODE_DISABLED
