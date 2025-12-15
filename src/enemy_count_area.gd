extends Area3D

signal count_changed(count: int)
signal count_zero

var _last_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Label3D.text = str(get_enemy_count())


func get_enemy_count() -> int:
	var count := get_overlapping_bodies().size()

	if count != _last_count:
		_last_count = count
		count_changed.emit(_last_count)
		if count == 0:
			count_zero.emit()

	return count
