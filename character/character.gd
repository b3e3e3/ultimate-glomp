class_name Character
extends CharacterBody2D

@export var ACCEL_SPEED: float = 30.0
@export var DECEL_SPEED: float = 80.0
@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: Vector2 = Vector2(0, -400.0)

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
	# direction = Vector2.RIGHT * sign(velocity.x) if velocity.x != 0 else direction

func disable_collision():
	Global.disable_collision($CollisionShape2D)

func enable_collision():
	Global.enable_collision($CollisionShape2D)

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func move(dir: float, speed: float = SPEED, accel: float = ACCEL_SPEED) -> void:
	var delta := accel
	var target := dir * speed

	if not dir and velocity.x:
		target = 0
		delta = DECEL_SPEED
	elif sign(dir) != sign(velocity.x):
		delta = DECEL_SPEED

	velocity.x = move_toward(velocity.x, target, delta)

func vertical_move(dir: float, speed: float = SPEED, accel: float = ACCEL_SPEED) -> void:
	velocity.y = dir * speed
	# if not dir and velocity.y:
	# 	velocity.y = move_toward(velocity.y, 0, DECEL_SPEED)
	# else:
	# 	velocity.y = move_toward(velocity.y, dir * speed, accel)

func jump(force: Vector2 = JUMP_VELOCITY) -> void:
	velocity.y = force.y
	if not is_zero_approx(force.x):
		velocity.x = force.x

func is_landed() -> bool:
	return is_on_floor() or velocity.y == 0

func is_moving() -> bool:
	return velocity.x != 0

func get_speed() -> float:
	return SPEED
