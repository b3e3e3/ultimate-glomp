class_name PlayerState extends CharacterState

var player: Player
var controller: PlayerController


func _ready() -> void:
	await super._ready()

	player = character as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")

	controller = Global.current_level.player_controller
	assert(player != null, "PlayerController is null.")

func on_update(_delta: float) -> void:
	var l: Label = player.get_node(^"CanvasLayer/Label")
	l.text = player.get_node(^"StateMachine").state.name + '\n'
	l.text += player.glomped_body.name as String if player.glomped_body else "No glomp"
	l.text += '\n' + 'can_coyote: ' + str($"../Falling".can_coyote)
	l.text += '\n' + 'vel: ' + str(player.velocity)
	l.text += '\n' + 'direction: ' + str(character.direction)

	super.on_update(_delta)

func on_physics_update(_delta: float) -> void:
	controller.control_direction()

func check_for_moving() -> bool:
	return controller.get_horizontal_input() or character.is_moving()

func check_for_jumping() -> bool:
	return controller.get_jump_input() and character.is_landed()

func check_for_glomping() -> bool:
	return player.glomped_body or not player.get_glomped_bodies().is_empty()

func check_for_throwing() -> bool:
	return controller.get_jump_input() and player.glomped_body

func check_for_grabbing() -> bool:
	return character.is_on_wall() and not player.get_climbable_bodies_in_proximity().is_empty()

func check_for_climbing() -> bool:
	return controller.get_vertical_input()
