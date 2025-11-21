class_name MessageInteraction extends Interaction

@export var max_lines: int = 2
@export_multiline var messages: Array[String] = [
	"Hello, world! I'm fucking crazy, dog! Fuck!",
	"Welcome to glomp city fool...",
	"Whatever you do, don't spill the beans."
]

var msg_idx: int = 0

# var label: TypewriterLabel
var box: MessageBox


func on_start() -> void:
	msg_idx = -1

	next_message()

func initialize(owner: Node3D):
	box = Global.create_message_box(Global.pos2screen(owner.global_position))

func next_message() -> void:
	if not messages.is_empty():
		if msg_idx < messages.size() - 1:
			msg_idx += 1
			box.start_message(messages[msg_idx])
			return

	finish()

func on_step() -> void:
	if box.label.is_typewriter_finished():
		next_message()
	else:
		box.skip()

func on_finish() -> void:
	await box.finish()
	box = null
