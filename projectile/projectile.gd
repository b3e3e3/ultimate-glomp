class_name Projectile extends RigidBody2D

signal finished


@export var speed: float = 1000
@export var spin_speed: float = 2000

var direction: Vector2 = Vector2(1, 0)


func _enter_tree() -> void:
	body_entered.connect(_on_body_entered)

func _exit_tree() -> void:
	body_entered.disconnect(_on_body_entered)

func _ready() -> void:
	linear_damp = 0
	gravity_scale = 0

	linear_velocity = direction * speed

func _physics_process(delta: float) -> void:
	$Sprite2D.rotation_degrees += delta * get_spin_speed()

func _on_body_entered(_body: Node) -> void:
	spinout()

func get_spin_speed() -> float:
	return spin_speed * sign(linear_velocity.x)
	# return linear_velocity.length() * 2
	# return linear_velocity.x * spin_speed

func spinout() -> void:
	$CollisionShape2D.set_deferred(&"disabled", true)

	linear_velocity = (-direction * speed * 0.4) + (Vector2.UP * speed * 0.7)

	# linear_damp = 1.5
	spin_speed *= 1.5
	gravity_scale = 2

	await get_tree().create_timer(2.0).timeout

	finished.emit()
	queue_free()
