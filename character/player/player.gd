class_name Player extends Character

signal glomped(body: PhysicsBody2D)
signal unglomped(body: PhysicsBody2D)

@onready var glomp_area: Area2D = $GlompArea
@onready var climb_area: Area2D = $ClimbArea

var glomped_body: Node2D

var is_attacking: bool = false


func _enter_tree() -> void:
	super._enter_tree()
	set_collision_mask_value(2, true) # enable glompable layer

# func get_horizontal_input() -> float:
# 	return Input.get_axis(&"move_left", &"move_right")

# func get_jump_input() -> bool:
# 	return Input.is_action_just_pressed(&"jump")

func get_climbable_bodies_in_proximity() -> Array[Node2D]:
	return climb_area.get_overlapping_bodies()

func get_glomped_bodies() -> Array[Node2D]:
	return glomp_area.get_overlapping_bodies()

func attack():
	if is_attacking: return

	$ProjectileSpawner.spawn_projectile(direction)
	is_attacking = true
	$ProjectileSpawner.projectile_finished.connect((func(_p):
		is_attacking = false
	), CONNECT_ONE_SHOT)

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
	# reparent(body)

	if body.has_method(&"get_glomped"):
		body.call(&"get_glomped", self)
	glomped.emit(body)

func un_glomp() -> void:
	return
	# # move the glomped body back into the world
	# reparent(glomped_body.get_parent()) # TODO: find a better parent?

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

	# remove glomped body
	unglomped.emit(glomped_body)
	glomped_body = null
