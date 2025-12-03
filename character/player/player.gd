class_name Player extends Character

# TODO: these things don't exist on topdown player.
# they are never used, but maybe a way to utilize them without
# having direct references would be better
@onready var glomp_area: Area3D = $GlompArea
@onready var climb_area: Area3D = $ClimbArea

var glomped_body: Node3D
var is_attacking: bool = false


# hooks
func _enter_tree() -> void:
	super._enter_tree()
	set_collision_mask_value(2, true) # enable glompable layer

func _process(_delta: float) -> void:
	# super._process(_delta)
	__process_debug_hud()


# collisions
func get_climbable_bodies_in_proximity() -> Array[Node3D]:
	return climb_area.get_overlapping_bodies()

func get_glomped_bodies() -> Array[Node3D]:
	return glomp_area.get_overlapping_bodies()


# actions
func attack(aim_direction: Vector3 = self.direction):
	if is_attacking: return

	$ProjectileSpawner.spawn_projectile(aim_direction)

	attack_started.emit()
	is_attacking = true

	$ProjectileSpawner.projectile_finished.connect((func(_p):
		is_attacking = false
		attack_finished.emit()
	), CONNECT_ONE_SHOT)


# glomping
func glomp_on(body: PhysicsBody3D) -> void:
	# acquire glomped body
	assert(body.is_in_group(&"Glompable"))
	glomped_body = body

	# halt movement so when it is resumed, force is not carried over
	velocity = Vector3.ZERO

	# move the player body to the glomped body's glomp point
	var point := body.get_node(^"GlompPoint")
	global_position = point.global_position

	if body.has_method(&"get_glomped"):
		body.call(&"get_glomped", self)
	glomped.emit(body)

func un_glomp() -> void:
	return
	# # move the glomped body back into the world
	# reparent(glomped_body.get_parent()) # TODO: find a better parent?

	# # default distance
	var dist := 0.64

	# # calculate distance between player and glomped body to decide how far to send the player up
	if glomped_body:
		var player_rect: Rect2 = collision_shape.shape.get_rect()
		var body_rect: Rect2 = glomped_body.get_node(^"CollisionShape3D").shape.get_rect()

		dist = body_rect.position.distance_to(player_rect.position) + player_rect.size.y / 2
	else: push_warning("No glomped body to unglomp")

	# apply distance to player position
	global_position += Vector3.UP * dist

	# remove glomped body
	unglomped.emit(glomped_body)
	glomped_body = null


# debug
func __process_debug_hud():
	var l: Label = $"CanvasLayer/Label"
	l.text = state_machine.state.name + '\n'
	l.text += glomped_body.name as String if glomped_body else "No glomp"

	if has_node(^"../Falling"):
		l.text += '\n' + 'can_coyote: ' + str($"../Falling".can_coyote)
		l.text += '\n' + 'can_reverse_coyote: ' + str($"../Falling"._can_reverse_coyote)

	l.text += '\n' + 'vel: ' + str(velocity)
	l.text += '\n' + 'direction: %s | last_direction: %s' % [direction, last_direction]

	if equip_inventory:
		for e in equip_inventory.equipment:
			var text := e.debug_text()
			if text == "": continue
			l.text += '\n' + text
