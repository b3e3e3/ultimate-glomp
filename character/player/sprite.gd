class_name PlayerSprite extends Sprite3D

@onready var player: Player = owner

func _on_player_jumped() -> void:
	if player.combo_jump.current_combo == 3:
		do_flip(player.last_direction)

func do_flip(dir):
	var angle := 360.0 * (signf(dir.x))

	var tween := create_tween()\
		.set_ease(Tween.EASE_OUT)\
		.tween_property(self, ^"rotation_degrees", self.rotation_degrees + (Vector3.FORWARD * angle), 0.5)
	await tween.finished
