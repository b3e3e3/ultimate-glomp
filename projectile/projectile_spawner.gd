class_name ProjectileSpawner extends Node3D

signal projectile_finished(projectile: Projectile)

@export var projectile_scene: PackedScene

func spawn_projectile(dir: Vector3) -> Projectile:
	print("Projectile scene? ", projectile_scene)

	var projectile = projectile_scene.instantiate()
	# projectile = projectile as Projectile

	projectile.set_deferred(&"global_position", global_position)
	projectile.set_deferred(&"target_direction", dir)
	projectile.set_deferred(&"launched_by", owner)

	owner.get_parent().add_child(projectile)

	projectile.finished.connect(func():
		projectile_finished.emit(projectile)
	, CONNECT_ONE_SHOT)

	return projectile

func _on_thrown(by: Character) -> void:
	spawn_projectile(by.last_direction)

func _on_hit(by: Node3D) -> void:
	(func():
		if by is Projectile:
			by = by as Projectile
			var p := spawn_projectile(by.target_direction * Vector3.LEFT)
			p.global_position.y = by.global_position.y
			print("SYNCING YS")
			p.on_hit_finished()
	).call_deferred()
