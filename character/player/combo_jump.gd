class_name ComboJump extends Node

signal combo_added(combo: int)
signal timer_expired(combo: int)


@export var current_combo: int = -1
@export var cooldown_time: float = 0.1
@export var combo_limit: int = 3


@onready var timer: Timer = Timer.new()


func _ready():
	add_child(timer)
	timer.timeout.connect(_on_timeout)


func combo_limit_reached() -> bool:
	return current_combo >= combo_limit

func reset():
	current_combo = -1

func cancel_timer():
	timer.stop()

func progress() -> bool:
	timer.start(cooldown_time)

	if combo_limit_reached():
		reset()
		return false

	current_combo += 1
	combo_added.emit(current_combo)

	return true


func is_comboing() -> bool:
	return current_combo > 0


func _on_timeout():
	var old_combo := current_combo
	cancel_timer()
	reset()

	timer_expired.emit(old_combo)
