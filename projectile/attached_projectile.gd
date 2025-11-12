class_name AttachedProjectile extends Projectile

var retracting: bool = false

func get_spin_speed() -> float:
	return 0.0

func on_hit_finished() -> void:
	# target_direction = global_position.direction_to(launched_from)
	retracting = true

	$CollisionShape2D.set_deferred(&"disabled", true)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if retracting:
		target_direction = global_position.direction_to(launched_by.global_position)
		if global_position.distance_to(launched_by.global_position) < 32:
			queue_free()

func _exit_tree() -> void:
	finished.emit()
