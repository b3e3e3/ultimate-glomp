class_name Interaction extends Resource

signal started
signal stepped
signal finished
signal updated


func start() -> void:
	on_start()
	started.emit()

func step() -> void:
	on_step()
	stepped.emit()

func update(delta: float) -> void:
	on_update(delta)
	updated.emit()

func finish() -> void:
	on_finish()
	finished.emit()


func on_start() -> void: pass
func on_step() -> void: finish()
func on_update(_delta: float) -> void: pass
func on_finish() -> void: pass
