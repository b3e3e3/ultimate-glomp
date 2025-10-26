class_name CharacterBody
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var _direction: float = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if should_move():
		velocity.x = _direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# func _on_area_2d_body_entered(body: Object) -> void:
# 	if body is Node2D:
# 		$Sprite2D.reparent.call_deferred(body)

func move(direction: float) -> void:
	_direction = direction

func jump() -> void:
	if can_jump():
		velocity.y = JUMP_VELOCITY

func should_move() -> bool:
	return _direction != 0.0

func can_jump() -> bool:
	return is_on_floor()
