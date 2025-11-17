class_name ComboJump extends Node


signal jumped(combo: int)
signal combo_added(combo: int)
signal timer_expired(combo: int)


@export var current_combo: int = -1
@export var cooldown_time: float = 0.1
@export var combo_limit: int = 3


@onready var timer: Timer = Timer.new()

@onready var character: Character = get_parent() as Character


func _ready():
	add_child(timer)
	timer.timeout.connect(_on_timeout)

	character.jumped.connect(_on_character_jump)


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
	print("COMBO ADDED!")

	return true


func is_comboing() -> bool:
	return current_combo > 0


func _on_timeout():
	var old_combo := current_combo
	cancel_timer()
	reset()

	timer_expired.emit(old_combo)

func _on_character_jump():
	jumped.emit(current_combo)


func get_jump_force() -> Vector3:
	return (character.get_jump_force() / 3) * (max(0, current_combo - 1) as int)
