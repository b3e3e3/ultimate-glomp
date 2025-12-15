class_name LedgeGrabState extends PlayerState

@export var grab_cooldown: float = 0.3

@onready var jump_state: State = $"../Jumping"
@onready var falling_state: State = $"../Falling"

@onready var area: Area3D


func on_enter(previous_state: State, data := {}) -> void:
	character.collision_shape.disabled = true
	character.velocity = Vector3.ZERO

	if not area: area = player.ledge_grab_area

	# var point := player.ledge_detector.get_collision_point()
	# var dist = (character.collision_shape.shape.size.x) * point.direction_to(character.global_position).x
	# var new_pos := (point + Vector3(dist, 0, 0))

	# character.global_position.x = new_pos.x
	# character.global_position.y = new_pos.y

	var point := area.get_overlapping_areas()[0].global_position

	character.global_position.x = point.x
	character.global_position.y = point.y

	character.move_enabled = false
	character.gravity_enabled = false


func on_exit() -> void:
	character.collision_shape.disabled = false

	area.get_node(^"CollisionShape3D").disabled = true
	await get_tree().create_timer(grab_cooldown).timeout
	area.get_node(^"CollisionShape3D").disabled = false

func on_physics_update(_delta: float) -> void:
	if check_for_jumping():
		goto(jump_state)
	elif check_for_moving_vertical():
		var ver := controller.get_vertical_input()
		if ver < 0:
			goto(falling_state)
