class_name TDPlayerState extends CharacterState

var player: TDPlayer
var controller: PlayerController


func _ready() -> void:
	await super._ready()

	player = character as TDPlayer
	assert(player != null, "The TDPlayerState state type must be used only in the player scene. It needs the owner to be a TDPlayer node.")

	controller = Global.current_level.player_controller
	assert(controller != null, "PlayerController is null.")

# func on_update(_delta: float) -> void:
# 	var l: Label = player.get_node(^"CanvasLayer/Label")
# 	l.text = player.get_node(^"StateMachine").state.name + '\n'
# 	l.text += player.glomped_body.name as String if player.glomped_body else "No glomp"
# 	l.text += '\n' + 'can_coyote: ' + str($"../Falling".can_coyote)
# 	l.text += '\n' + 'can_reverse_coyote: ' + str($"../Falling"._can_reverse_coyote)
# 	l.text += '\n' + 'vel: ' + str(player.velocity)
# 	l.text += '\n' + 'direction: %s | last_direction: %s' % [character.direction, character.last_direction]
# 	if player.has_node(^"ComboJump"):
# 		l.text += '\n' + 'jump_combo: ' + str(player.get_node(^"ComboJump").current_combo)

# 	super.on_update(_delta)

func on_physics_update(_delta: float) -> void:
	controller.control_horizontal_direction()
	controller.control_vertical_direction()


func check_for_moving() -> bool:
	return controller.get_multi_input() != Vector2.ZERO or character.velocity.length() != 0

## Returns true if the player is pressing the interact button.
func check_for_interacting() -> bool:
	return controller.get_interact_input()
