class_name Character
extends CharacterBody2D

const ACCEL_SPEED: float = 30.0
const DECEL_SPEED: float = 80.0
const SPEED: float = 200.0
const JUMP_VELOCITY: float = -400.0

var gravity_enabled: bool = true
var move_enabled: bool = true

var direction: Vector2 = Vector2.RIGHT

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	if gravity_enabled:
		apply_gravity(delta)

	if move_enabled:
		move_and_slide()

	# TODO: better direction calculation
	direction = Vector2.RIGHT * sign(velocity.x) if velocity.x != 0 else direction

func disable_collision():
	Global.disable_collision($CollisionShape2D)

func enable_collision():
	Global.enable_collision($CollisionShape2D)

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

func is_landed() -> bool:
	return is_on_floor() or velocity.y == 0

func is_moving() -> bool:
	return velocity.x != 0
