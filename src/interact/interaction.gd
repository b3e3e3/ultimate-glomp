class_name GameAction extends Resource

signal started
signal stepped
signal finished(success: bool)
signal updated

var _start_count: int = 0

@export var one_shot: bool = false

var current_character: Character = null

func start(_character: Character = null) -> void:
	if one_shot and _start_count > 0:
		finish(false)
		return

	current_character = _character

	on_start(_character)
	started.emit()

	_start_count += 1

func step() -> void:
	on_step()
	stepped.emit()

func update(delta: float) -> void:
	on_update(delta)
	updated.emit()

func finish(success: bool = true) -> void:
	on_finish(success)
	finished.emit(success)


func on_start(_character: Character = null) -> void: step()
func on_step() -> void: finish()
func on_update(_delta: float) -> void: pass
func on_finish(_success: bool) -> void: pass

func initialize(_owner: Node3D): pass
