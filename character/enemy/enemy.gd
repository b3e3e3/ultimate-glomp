extends Character

signal thrown(by: Character)

func get_thrown(by: Character):
	print("whee!!")
	process_mode = PROCESS_MODE_INHERIT

	reparent(by.get_parent())
	collision_shape.reparent(self)

	# delete self and emit thrown signal
	queue_free()
	thrown.emit(by)

func get_glomped(by: Character):
	print("Glomped by " + by.name)

	reparent(by)
	collision_shape.reparent(by)
	process_mode = PROCESS_MODE_DISABLED
