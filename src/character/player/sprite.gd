class_name PlayerSprite extends Sprite3D

@export var lock_rotation: bool = false

@onready var sprite: Sprite2D = $SubViewport/Sprite2D

var tween: Tween = null

# func _on_player_jumped() -> void:
# func _on_combo_jump_jumped(current_combo: int) -> void:

func set_sprite(tex: Texture):
	$SubViewport/Sprite2D.texture = tex
	self.texture = $SubViewport.get_texture()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

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
		.tween_property(sprite, ^"rotation_degrees", sprite.rotation_degrees + angle, 0.5)
	await tween.finished
	tween = null


func _on_state_machine_state_changed(new_state: State, _previous_state: State, data: Dictionary) -> void:
	match new_state.name:
		&"Climbing":
			cancel_flip()

func _physics_process(delta: float) -> void:
	if not tween and not lock_rotation:
		sprite.rotation_degrees = -owner.rotation_degrees.z
