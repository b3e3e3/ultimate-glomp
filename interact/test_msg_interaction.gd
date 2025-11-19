class_name MessageInteraction extends Interaction


@export var typewriter_speed: float = 0.05
@export_multiline var messages: Array[String] = [
	"Hello, world! I'm fucking crazy, dog! Fuck!",
	"Welcome to glomp city fool...",
	"Whatever you do, don't spill the beans."
]

var msg_idx: int = 0

var label: RichTextLabel


func get_current_message() -> String: return messages[msg_idx]

func is_message_finished() -> bool:
	return label and label.visible_characters >= messages[msg_idx].length()

func on_start() -> void:
	msg_idx = -1

	label = Global.current_level.get_node(^"CanvasLayer/MarginContainer/RichTextLabel")
	label.visible = true
	label.visible_characters = 0

	next_message()

func next_message() -> void:
	if not messages.is_empty():
		if msg_idx < messages.size() - 1:
			msg_idx += 1

			label.visible_characters = 0
			label.text = get_current_message()

			start_typewriter()
			return

	finish()

func on_step() -> void:
	if is_message_finished():
		next_message()
	else:
		label.visible_characters = get_current_message().length()

func on_finish() -> void:
	label.visible = false

func start_typewriter() -> void:
	if label and not is_message_finished():
		Global.get_tree().create_timer(typewriter_speed).timeout.connect(func():
			label.visible_characters += 1
			start_typewriter()
		, CONNECT_ONE_SHOT)
	else:
		print("Typewriter done")
