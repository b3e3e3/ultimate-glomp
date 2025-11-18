class_name TDPlayer extends Character


func _ready() -> void:
	gravity_enabled = false

func get_stat_with_buffs(_key: StringName, value: Variant):
	return value

func move_multi(dir: Vector2, speed: float = get_speed(), accel: float = get_accel_speed(), decel: float = get_decel_speed()) -> void:
	var target := Vector3(dir.x, 0, dir.y) * speed
	var delta := accel

	if not dir and velocity:
		target = Vector3.ZERO
		delta = decel

	velocity = velocity.move_toward(target, delta)
