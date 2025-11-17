class_name Character
extends CharacterBody3D

signal jumped


@export var ACCEL_SPEED: float = 3.0
@export var ACCEL_SPEED_AIR: float =  0.15

@export var DECEL_SPEED: float = 8.0
@export var DECEL_SPEED_AIR: float = 0.03

@export var SPEED: float = 2.0
@export var SPEED_AIR: float = 2.0

@export var JUMP_VELOCITY: Vector3 = Vector3(0, 4.0, 0)
@export var WALL_SLIDE_SPEED: float = 1.0

@export var equipment: Array[Equipment] = []


var gravity_enabled: bool = true
var move_enabled: bool = true

var _direction: Vector3 = Vector3.RIGHT

var last_direction: Vector3 = _direction
var direction: Vector3:
	get:
		return _direction
	set(value):
		_direction = value
		last_direction.x = value.x if value.x != 0 else last_direction.x
		last_direction.y = value.y if value.y != 0 else last_direction.y

@onready var collision_shape: CollisionShape3D = $CollisionShape3D

func _enter_tree() -> void:
	set_collision_mask_value(1, true) # enable ground layer

func _physics_process(delta: float) -> void:
	if gravity_enabled:
		apply_gravity(delta)

	if move_enabled:
		move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func move(dir: float, speed: float = get_speed(), accel: float = get_accel_speed(), decel: float = get_decel_speed()) -> void:
	var delta := accel
	var target := dir * speed

	if not dir and velocity.x:
		target = 0
		delta = decel

	velocity.x = move_toward(velocity.x, target, delta)

func vertical_move(dir: float, speed: float = get_speed(), accel: float = get_accel_speed()) -> void:
	var target := dir * speed

	if not dir and velocity.y:
		target = 0

	velocity.y = move_toward(velocity.y, target, accel)

func jump(force: Vector3 = JUMP_VELOCITY) -> void:
	print("Jumping with force: ", force)

	velocity.y = force.y
	jumped.emit()
	if not is_zero_approx(force.x):
		velocity.x = force.x

func is_landed() -> bool:
	return is_on_floor() or velocity.y == 0

func is_moving() -> bool:
	return velocity.x != 0


func get_jumps_after_climbing() -> int:
	var _jumps := 0

	for e in equipment:
		_jumps += e.get_jumps_after_climbing(self, _jumps)
		# print(e.name, " added to jumps")

	return _jumps

func get_speed() -> float:
	var _speed := SPEED

	for e in equipment:
		_speed += e.get_speed(self, _speed)
		# print(e.name, " added to speed")

	return _speed

func get_decel_speed() -> float:
	var _decel := DECEL_SPEED
	if not is_on_floor():
		_decel = DECEL_SPEED_AIR

	for e in equipment:
		_decel += e.get_decel_speed(self, _decel)
		# print(e.name, " added to decel speed")

	return _decel

func get_accel_speed() -> float:
	var _accel := ACCEL_SPEED
	if not is_on_floor():
		_accel = ACCEL_SPEED_AIR

	for e in equipment:
		_accel += e.get_accel_speed(self, _accel)
		# print(e.name, " added to accel speed")

	return _accel

func get_jump_force() -> Vector3:
	var _vel := JUMP_VELOCITY

	for e in equipment:
		_vel += e.get_jump_force(self, _vel)
		# print(e.name, " added to jump force")

	return _vel

func get_wall_slide_speed() -> float:
	var _speed := WALL_SLIDE_SPEED

	for e in equipment:
		_speed += e.get_wall_slide_speed(self, _speed)
		# print(e.name, " added to wall slide speed")

	return _speed
