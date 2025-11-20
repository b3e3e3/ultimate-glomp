class_name PlayerSprite extends Sprite3D

@onready var player: Player = owner

var tween: Tween = null

# func _on_player_jumped() -> void:
# func _on_combo_jump_jumped(current_combo: int) -> void:

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


func _on_state_machine_state_changed(new_state: State, _previous_state: State) -> void:
	match new_state.name:
		&"Climbing":
			cancel_flip()
