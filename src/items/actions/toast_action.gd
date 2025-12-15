class_name ToastAction extends GameAction

@export var message: String = "Toast message!"

func execute(_character: Character = null) -> void:
	Global.create_toast(message)
