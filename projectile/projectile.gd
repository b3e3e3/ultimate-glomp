class_name Projectile extends RigidBody3D

signal finished

@export var offset: Vector3 = Vector3(0.2, 0, 0)
@onready var launched_from: Vector3 = self.global_position

@export var speed: float = 1000
@export var spin_speed: float = 2000

var target_direction: Vector3 = Vector3.RIGHT
var _direction: Vector3 = target_direction

var spinning_out: bool = false

var launched_by: Node3D

func _enter_tree() -> void:
	body_entered.connect(_on_body_entered)

	set_collision_layer_value(1, false) # disable default layer
	set_collision_layer_value(7, true) # enable projectile layer

	set_collision_mask_value(1, true) # enable ground layer

func _exit_tree() -> void:
	body_entered.disconnect(_on_body_entered)

func _ready() -> void:
	linear_damp = 0
	gravity_scale = 0

	print("TARGET DIR:", target_direction)

	lock_rotation = true
	_direction = target_direction
	linear_velocity = _direction * speed

	contact_monitor = true
	max_contacts_reported = 1

func _physics_process(delta: float) -> void:
	$Sprite.rotation_degrees.z += delta * get_spin_speed()

	if not _direction.is_equal_approx(target_direction) and not spinning_out:
		_direction = _direction.slerp(target_direction, delta * 50)
		linear_velocity = _direction * speed

func _on_body_entered(body: Node) -> void:
	if body.has_method(&"get_hit"):
		body.get_hit(self)
	print("AKJHGKDJFHG")
	on_hit_finished()

func get_spin_speed() -> float:
	return spin_speed * -sign(linear_velocity.x)
	# return linear_velocity.length() * 2
	# return linear_velocity.x * spin_speed

func on_hit_finished() -> void:
	print(name, " spinning out")
	$CollisionShape3D.set_deferred(&"disabled", true)

	linear_velocity = (-target_direction * speed * 0.25) + (Vector3.UP * speed * 0.7)
	print(linear_velocity)

	# linear_damp = 1.5
	lock_rotation = false
	spin_speed *= 1.5
	gravity_scale = 2

	spinning_out = true

	await get_tree().create_timer(2.0).timeout

	finished.emit()
	queue_free()
