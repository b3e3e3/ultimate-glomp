class_name AttachedProjectile extends Projectile

var retracting: bool = false

@onready var line: Line2D = $Line2D


func get_spin_speed() -> float:
	return 0.0

func on_hit_finished() -> void:
	retracting = true
	$CollisionShape2D.set_deferred(&"disabled", true)


func _ready() -> void:
	super._ready()
	await get_tree().create_timer(0.25).timeout
	if not retracting:
		on_hit_finished()

func _physics_process(delta: float) -> void:
	line.points[1] = launched_by.global_position - global_position

	super._physics_process(delta)
	if retracting:
		target_direction = global_position.direction_to(launched_by.global_position)
		if global_position.distance_to(launched_by.global_position) < 32:
			queue_free()

func _exit_tree() -> void:
	finished.emit()
