class_name ToastAction extends GameAction

@export var message: String = "Toast message!"


func on_start(_character: Character, _owner: Node) -> void:
	Global.create_toast(message)
	finish()
