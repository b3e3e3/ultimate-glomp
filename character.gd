class_name CharacterBody
extends CharacterBody2D

signal glomped(whom: CharacterBody)

var _direction: float = 0.0
var _speed: float = 300.0

var _is_frozen: bool = false
var is_frozen: bool:
	get:
		return _is_frozen
	set(value):
		if value:
			_direction = 0.0
			velocity = Vector2.ZERO
		_is_frozen = value

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not is_frozen:
		velocity += get_gravity() * delta

	if should_move():
		velocity.x = _direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)

	move_and_slide()

func disable() -> void:
	$CollisionShape2D.set_deferred(&"disabled", true)
	set_deferred(&"is_frozen", true)

func enable() -> void:
	$CollisionShape2D.set_deferred(&"disabled", false)
	set_deferred(&"is_frozen", false)

func _on_area_2d_body_entered(body: Object) -> void:
	if body is CharacterBody:
		glomped.emit(body)

func move(direction: float, speed: float = _speed) -> void:
	if is_frozen: return
	_direction = direction
	_speed = speed

func jump(jump_velocity: float = -400.0) -> void:
	if can_jump():
		velocity.y = jump_velocity

func should_move() -> bool:
	return _direction != 0.0

func can_jump() -> bool:
	return is_on_floor()
