class_name TDPlayerState extends PlayerState

var td_player: TDPlayer:
	get: return player as TDPlayer


func _ready() -> void:
	await super._ready()

	assert(td_player != null, "The TDPlayerState state type must be used only in the player scene. It needs the owner to be a TDPlayer node.")

# override
func on_physics_update(_delta: float) -> void:
	controller.control_horizontal_direction()
	controller.control_vertical_direction()

# override
func on_update(_delta: float) -> void: pass

# overide
func check_for_moving() -> bool:
	return controller.get_multi_input() != Vector2.ZERO or character.velocity.length() != 0
