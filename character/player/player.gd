class_name Player extends Character

signal glomped(body: PhysicsBody2D)
signal unglomped(body: PhysicsBody2D)

var glomped_body: Node2D

# func jump(force: float = JUMP_VELOCITY) -> void:
# 	if glomped_body and get_parent() == glomped_body:
# 		glomped_body.remove_child(self)
# 		glomped_body.reparent(self)

# 	super.jump(force)

# func move(dir: float, accel: float = ACCEL_SPEED, speed: float = SPEED) -> void:
# 	if glomped_body and glomped_body.has_method(&"move"):
# 		glomped_body.call(&"move", dir, accel, speed)
# 		return

# 	super.move(dir, accel, speed)

# func is_moving() -> bool:
# 	if glomped_body and glomped_body.has_method(&"is_moving"):
# 		return glomped_body.call(&"is_moving")
# 	return super.is_moving()

# func _physics_process(delta: float) -> void:
# 	if glomped_body and is_landed():
# 		if is_landed() and glomped_body.get_parent() == self:
# 			remove_child(glomped_body)
# 			reparent(glomped_body)

# 	super._physics_process(delta)

func get_horizontal_input() -> float:
	return Input.get_axis(&"move_left", &"move_right")

func get_jump_input() -> bool:
	return Input.is_action_just_pressed(&"jump")

func get_glomped_bodies() -> Array[Node2D]:
	return $GlompArea.get_overlapping_bodies()

func glomp_on(body: PhysicsBody2D) -> void:
	# acquire glomped body
	assert(body.is_in_group(&"Glompable"))
	glomped_body = body

	# halt movement so when it is resumed, force is not carried over
	velocity = Vector2.ZERO

	# move the player body to the glomped body's glomp point
	global_position = body.get_node(^"GlompPoint").global_position

	# disable our collision shape
	# collision_shape.disabled = true

	# reparent player to glomped body
	reparent(body)

	# disable processing to prevent movement
	body.process_mode = Node.PROCESS_MODE_DISABLED

	glomped.emit(body)

func un_glomp() -> void:
	# # move the glomped body back into the world
	reparent(glomped_body.get_parent()) # TODO: find a better parent?

	# # default distance
	var dist := 64.0

	# # calculate distance between player and glomped body to decide how far to send the player up
	if glomped_body:
		var player_rect: Rect2 = collision_shape.shape.get_rect()
		var body_rect: Rect2 = glomped_body.get_node(^"CollisionShape2D").shape.get_rect()

		dist = body_rect.position.distance_to(player_rect.position) + player_rect.size.y / 2
	else: push_warning("No glomped body to unglomp")

	# apply distance to player position
	global_position += Vector2.UP * dist

	# resume processing
	glomped_body.process_mode = Node.PROCESS_MODE_INHERIT

	# remove glomped body
	unglomped.emit(glomped_body)
	glomped_body = null
