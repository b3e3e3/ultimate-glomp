class_name GuardAction extends GameAction

signal success
signal failure

@export var on_success: GameAction
@export var on_failure: GameAction


func initialize(owner: Node3D):
	on_success.initialize(owner)
	on_failure.initialize(owner)

func start(character: Character = null) -> void:
	if is_successful():
		if on_success:
			print("Success!")
			on_success.start(current_character)

		super.start(character)
		success.emit()
	else:
		if on_failure:
			print("Failed.")
			on_failure.start(current_character)

		finish(false)
		failure.emit()

func is_successful() -> bool: return true
