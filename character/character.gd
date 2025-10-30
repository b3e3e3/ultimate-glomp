class_name Character
extends CharacterBody2D

const ACCEL_SPEED: float = 30.0
const DECEL_SPEED: float = 80.0
const SPEED: float = 200.0
const JUMP_VELOCITY: float = -400.0

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_and_slide()

func disable_collision():
	$CollisionShape2D.set_deferred(&"disabled", true)

func enable_collision():
	$CollisionShape2D.set_deferred(&"disabled", false)

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func move(dir: float, accel: float = ACCEL_SPEED, speed: float = SPEED) -> void:
	if not dir and velocity.x:
		velocity.x = move_toward(velocity.x, 0, DECEL_SPEED)
	else:
		velocity.x = move_toward(velocity.x, dir * speed, accel)

func jump(force: float = JUMP_VELOCITY) -> void:
	velocity.y = force

func can_jump() -> bool:
	return is_on_floor() or velocity.y == 0
