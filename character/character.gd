class_name Character
extends CharacterBody3D

signal jumped

signal attack_started
signal attack_finished

signal glomped(body: PhysicsBody3D)
signal unglomped(body: PhysicsBody3D)

@export var ACCEL_SPEED: float = 3.0
@export var ACCEL_SPEED_AIR: float =  3.0

@export var DECEL_SPEED: float = 8.0
@export var DECEL_SPEED_AIR: float = 0.03

@export var SPEED: float = 2.0
@export var SPEED_AIR: float = 2.0

@export var JUMP_VELOCITY: Vector3 = Vector3(0, 4.0, 0)
@export var WALL_SLIDE_SPEED: float = 1.0

@export var gravity_enabled: bool = true
@export var move_enabled: bool = true

var remaining_jumps: int = 0

var _direction: Vector3 = Vector3.RIGHT

var last_direction: Vector3 = _direction
var direction: Vector3:
	get:
		return _direction
	set(value):
		_direction = value
		last_direction.x = value.x if value.x != 0 else last_direction.x
		last_direction.y = value.y if value.y != 0 else last_direction.y

@onready var state_machine: StateMachine = $StateMachine
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var equip_inventory: EquipInventory = $EquipInventory
@onready var item_inventory: ItemInventory = $ItemInventory
@onready var floor_cast: RayCast3D = $FloorCast as RayCast3D


# hooks
func _enter_tree() -> void:
	set_collision_mask_value(1, true) # enable ground layer


func _physics_process(delta: float) -> void:
	if gravity_enabled:
		apply_gravity(delta)

	if move_enabled:
		move_and_slide()

	var target_rot: float = 0

	if is_on_floor() and floor_cast.is_colliding():
		target_rot = -floor_cast.get_collision_normal().x
	elif is_on_wall(): # TODO: wall normals
		pass

	global_rotation.z = move_toward(global_rotation.z, target_rot, delta * 10)
# movement
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func move_horizontal(dir: float, speed: float = get_speed(), accel: float = get_accel_speed(), decel: float = get_decel_speed()) -> void:
	var delta := accel
	var target := dir * speed

	if not dir and velocity.x:
		target = 0
		delta = decel

	velocity.x = move_toward(velocity.x, target, delta)

func move_vertical(dir: float, speed: float = get_speed(), accel: float = get_accel_speed()) -> void:
	var target := dir * speed

	if not dir and velocity.y:
		target = 0

	velocity.y = move_toward(velocity.y, target, accel)

func move_multi(dir: Vector2, speed: float = get_speed(), accel: float = get_accel_speed(), decel: float = get_decel_speed()) -> void:
	var delta := accel
	var target := Vector3(dir.x, 0, dir.y) * speed

	if not dir and velocity:
		target = Vector3.ZERO
		delta = decel

	velocity = velocity.move_toward(target, delta)

func jump(force: Vector3 = JUMP_VELOCITY) -> void:
	print("Jumping with force: ", force)

	if remaining_jumps > 0:
		remaining_jumps -= 1

	velocity.y = force.y
	jumped.emit()
	if not is_zero_approx(force.x):
		velocity.x = force.x


# checks
func is_landed() -> bool:
	return is_on_floor() or velocity.y == 0

func is_moving() -> bool:
	return velocity.x != 0


# stats
func get_stat_with_buffs(key: StringName, value: Variant):
	var val = value

	val += $EquipInventory.get_all_adds(key)
	val *= $EquipInventory.get_all_multipliers(key)

	return val

func get_jumps_after_climbing() -> int:
	var _jumps := 0

	_jumps = get_stat_with_buffs(&"jumps_after_climbing", _jumps)

	return _jumps

func get_speed() -> float:
	return _get_air_variant_stat(&"speed", &"air_speed", SPEED, SPEED_AIR)

func get_decel_speed() -> float:
	return _get_air_variant_stat(&"decel_speed", &"air_decel_speed", DECEL_SPEED, DECEL_SPEED_AIR)

func get_accel_speed() -> float:
	return _get_air_variant_stat(&"accel_speed", &"air_accel_speed", ACCEL_SPEED, ACCEL_SPEED_AIR)

func get_jump_force() -> Vector3:
	var _vel := JUMP_VELOCITY

	_vel = get_stat_with_buffs(&"jump_force", _vel)

	return _vel

func get_wall_slide_speed() -> float:
	var _speed := WALL_SLIDE_SPEED

	_speed = get_stat_with_buffs(&"wall_slide_speed", _speed)

	return _speed

func _get_air_variant_stat(grounded_key: StringName, air_key: StringName, grounded: Variant, air: Variant) -> Variant:
	var value: float
	var _key: StringName = grounded_key

	if is_on_floor():
		value = grounded
	else:
		value = air
		_key = air_key

	value = get_stat_with_buffs(_key, value)

	return value
