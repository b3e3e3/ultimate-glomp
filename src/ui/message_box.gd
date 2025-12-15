class_name MessageBox extends Control

@export var label: TypewriterLabel


func finish():
	# TODO: tween or something
	queue_free()
	label.visible = false

func skip():
	label.skip_typewriter()

func start_message(msg: String):
	# label.visible = false
	# TODO: tween or something
	label.visible = true
	label.start_typewriter(msg)
