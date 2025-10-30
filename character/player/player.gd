class_name Player extends Character

var last_glomped_body: Node2D

func _physics_process(_delta: float) -> void:
	move_and_slide()

func get_horizontal_input() -> float:
	return Input.get_axis(&"move_left", &"move_right")

func get_jump_input() -> bool:
	return Input.is_action_just_pressed(&"jump")

func get_glomped_bodies() -> Array[Node2D]:
	return $GlompArea.get_overlapping_bodies()

func glomp_on(body: PhysicsBody2D) -> void:
	assert(body.is_in_group(&"Glompable"))

	last_glomped_body = body

	velocity = Vector2.ZERO
	disable_collision()

	reparent.call_deferred(body)
	set_deferred(&'global_position', body.get_node(^"GlompPoint").global_position)

func un_glomp() -> void:
	var dist := 48.0

	if last_glomped_body:
		reparent.call_deferred(last_glomped_body.get_parent()) # TODO: find a better parent?

		var player_rect: Rect2 = $CollisionShape2D.shape.get_rect()
		var glomp_rect: Rect2 = $GlompArea/CollisionShape2D.shape.get_rect()
		var body_rect: Rect2 = last_glomped_body.get_node(^"CollisionShape2D").shape.get_rect()

		dist = body_rect.position.distance_to(glomp_rect.position) + player_rect.size.y / 2
	else:
		push_warning("Did not find last glomped body, moving a default distance of %s" % dist)

	global_position += Vector2.UP * dist
	enable_collision()
