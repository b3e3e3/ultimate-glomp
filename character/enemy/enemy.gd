extends Character

signal thrown(by: Character)
signal hit(by: Node2D)

func _enter_tree() -> void:
	super._enter_tree()
	set_collision_mask_value(3, true) # enable player layer
	set_collision_mask_value(7, true) # enable projectile layer

func get_thrown(by: Character):
	process_mode = PROCESS_MODE_INHERIT

	reparent(by.get_parent())
	collision_shape.reparent(self)

	# delete self and emit thrown signal
	queue_free()
	thrown.emit(by)

func get_hit(by: Node2D):
	queue_free()
	hit.emit(by)

func get_glomped(by: Character):
	reparent(by)
	collision_shape.reparent(by)
	process_mode = PROCESS_MODE_DISABLED
