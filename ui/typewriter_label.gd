class_name TypewriterLabel extends RichTextLabel

@export var default_speed: float = 0.05


func _ready() -> void:
	visible = false
	visible_characters = 0
	text = ""

func start_typewriter(message: String = text) -> void:
	visible = true
	if message != text:
		visible_characters = 0
		text = message

	if not is_typewriter_finished():
		Global.get_tree().create_timer(default_speed).timeout.connect(func():
			visible_characters += 1

			# var line_count := label.get_visible_line_count()
			# if line_count > max_lines:
			# 	var line_range := label.get_line_range(line_count)
			# 	label.text = label.text.substr(line_range[0], line_range[1])

			# print("visible lines: ", label.get_visible_line_count(), "\n", )

			start_typewriter()
		, CONNECT_ONE_SHOT)
	else:
		print("Typewriter done")


func is_typewriter_finished() -> bool:
	return visible_characters >= text.length()

func skip_typewriter() -> void:
	visible_characters = text.length()
