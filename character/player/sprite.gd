class_name PlayerSprite extends Sprite3D

@onready var player: Player = owner

var tween: Tween = null

func _on_player_jumped() -> void:
	if player.combo_jump.current_combo == 3:
		do_flip(player.last_direction)

func cancel_flip():
	if not tween: return

	tween.stop()
	tween = null
	rotation_degrees = Vector3.ZERO


func do_flip(dir):
	var angle := 360.0 * (signf(dir.x))

	tween = create_tween()
	tween\
		.set_ease(Tween.EASE_OUT)\
		.tween_property(self, ^"rotation_degrees", self.rotation_degrees + (Vector3.FORWARD * angle), 0.5)
	await tween.finished
	tween = null
