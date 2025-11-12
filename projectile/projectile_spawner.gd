class_name ProjectileSpawner extends Node2D

signal projectile_finished(projectile: Projectile)

@export var projectile_scene: PackedScene

func spawn_projectile(dir: Vector2) -> Projectile:
	var projectile := projectile_scene.instantiate() as Projectile

	projectile.global_position = global_position
	projectile.target_direction = dir
	projectile.launched_by = owner

	owner.get_parent().add_child(projectile)

	projectile.finished.connect(func():
		projectile_finished.emit(projectile)
	, CONNECT_ONE_SHOT)

	return projectile

func _on_thrown(by: Character) -> void:
	print("On thrown")
	spawn_projectile(by.direction)

func _on_hit(by: Node2D) -> void:
	(func():
		print("On hit")
		if by is Projectile:
			by = by as Projectile
			var p := spawn_projectile(-by.target_direction)
			p.global_position.y = by.global_position.y
			p.on_hit_finished()
	).call_deferred()
