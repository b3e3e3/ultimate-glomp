class_name ProjectileSpawner extends Node3D

signal projectile_spawned(projectile: Projectile)
signal projectile_finished(projectile: Projectile)

@export var projectile_scene: PackedScene

func spawn_projectile(dir: Vector3) -> Projectile:
	var projectile = projectile_scene.instantiate() as Projectile

	owner.get_parent().add_child(projectile)

	projectile.global_position = global_position + (projectile.offset * dir)
	projectile.target_direction = dir
	projectile.launched_by = owner

	projectile.finished.connect(func():
		projectile_finished.emit(projectile)
	, CONNECT_ONE_SHOT)

	projectile_spawned.emit(projectile)
	return projectile

func _on_thrown(by: Character) -> void:
	var _p := spawn_projectile(by.last_direction)

func _on_hit(by: Node3D) -> void:
	var p := spawn_projectile(-by.target_direction)

	if by is Projectile:
		p.global_position.y = by.global_position.y
		print("SYNCING YS")
		p.on_hit_finished()
