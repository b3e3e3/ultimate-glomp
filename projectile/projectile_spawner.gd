extends Node2D

signal projectile_finished(projectile: Projectile)

@export var projectile_scene: PackedScene

func spawn_projectile(dir: Vector2) -> Projectile:
	var projectile := projectile_scene.instantiate() as Projectile

	projectile.global_position = global_position
	projectile.direction = dir
	owner.get_parent().add_child(projectile)

	projectile.finished.connect(func():
		projectile_finished.emit(projectile)
	, CONNECT_ONE_SHOT)

	return projectile

func _on_thrown(by: Character) -> void:
	spawn_projectile(by.direction)
