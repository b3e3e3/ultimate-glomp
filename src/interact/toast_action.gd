class_name ToastAction extends GameAction

@export var message: String = "Toast message!"


func on_start(_character: Character = null) -> void:
	Global.create_toast(message)
	finish()
