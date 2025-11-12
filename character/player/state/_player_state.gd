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

## Returns true if horizontal input is non-zero or the character is moving.
func check_for_moving_horizontal() -> bool:
	return controller.get_horizontal_input() or character.is_moving()

## Returns true if the jump button is pressed and the character is landed.
func check_for_jumping() -> bool:
	return controller.get_jump_input() and character.is_landed()

## Returns true if the player has a glomped body, or there is one in its vicinity.
func check_for_glomping() -> bool:
	return player.glomped_body or not player.get_glomped_bodies().is_empty()

## Returns true if the player is jumping while holding a glomped body.
func check_for_throwing() -> bool:
	return controller.get_jump_input() and player.glomped_body

## Returns true if the player is grabbing onto a wall, and there is a climbable wall nearby.
func check_for_climbing() -> bool:
	return character.is_on_wall() and not player.get_climbable_bodies_in_proximity().is_empty()

## Returns true if the player is trying to move vertically.
func check_for_moving_vertical() -> bool:
	return controller.get_vertical_input()

## Returns true if the player is trying to attack.
func check_for_attacking() -> bool:
	return controller.get_attack_input()

## Checks if the player is trying to move in the direction they are already moving.
## If so, a timer starts of @param time seconds.
## If the player is still trying to move in the same direction, returns true.
func check_for_swapping(time: float) -> bool:
	var hor := controller.get_horizontal_input()

	# if we are trying to move in our current direction, start a timer to swap sides
	if character.direction.x == hor and hor != 0 \
	and controller.just_pressed_horizontal():
		await get_tree().create_timer(time).timeout

		# if we are still trying to swap and still not moving, we can swap
		return controller.get_horizontal_input() != 0 \
				and character.velocity.length() == 0

	return false
