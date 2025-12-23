class_name GuardAction extends GameAction

signal success
signal failure

@export var on_success: GameAction
@export var on_failure: GameAction

var _was_successful: bool = false

# func initialize(owner: Node3D):
# 	on_success.initialize(owner)
# 	on_failure.initialize(owner)

func on_start(character: Character, owner: Node) -> void:
	if is_successful():
		if on_success:
			print("Success!")
			_was_successful = true
			on_success.finished.connect(_on_action_finished)
			on_success.start(character, owner)

		# super.start(character, owner)
		success.emit()
	else:
		if on_failure:
			print("Failed.")
			_was_successful = false
			on_failure.finished.connect(_on_action_finished)
			on_failure.start(character, owner)

		failure.emit()

func _on_action_finished(_success: bool):
	finish(_was_successful)

func is_successful() -> bool: return true

func on_step() -> void: pass
