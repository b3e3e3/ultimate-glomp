class_name PlayerSprite extends Sprite2D

@onready var player: Player = owner

func _on_player_jumped() -> void:
	if player.combo_jump.current_combo == 3:
		do_flip(player.direction)

func do_flip(dir):
	var angle := 360
	if dir.x < 0:
		angle *= -1

	var tween := create_tween()\
		.set_ease(Tween.EASE_OUT)\
		.tween_property(self, ^"rotation_degrees", self.rotation_degrees + angle, 0.5)
	await tween.finished
