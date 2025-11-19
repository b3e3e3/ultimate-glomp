class_name MessageInteraction extends Interaction

@export var max_lines: int = 2
@export_multiline var messages: Array[String] = [
	"Hello, world! I'm fucking crazy, dog! Fuck!",
	"Welcome to glomp city fool...",
	"Whatever you do, don't spill the beans."
]

var msg_idx: int = 0

var label: TypewriterLabel


func on_start() -> void:
	msg_idx = -1
	label = Global.current_level.get_node(^"CanvasLayer/TypewriterLabel")

	next_message()

func next_message() -> void:
	if not messages.is_empty():
		if msg_idx < messages.size() - 1:
			msg_idx += 1
			label.start_typewriter(messages[msg_idx])
			return

	finish()

func on_step() -> void:
	if label.is_typewriter_finished():
		next_message()
	else:
		label.skip_typewriter()

func on_finish() -> void:
	label.visible = false
