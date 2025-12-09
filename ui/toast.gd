extends CenterContainer


func display(message: String, duration: float = 3.0) -> void:
	$NinePatchRect/MarginContainer/RichTextLabel.text = message
	await get_tree().create_timer(duration).timeout
	queue_free()
