class_name PlayerState extends CharacterState

var player: Player:
	get: return character as Player
var controller: PlayerController


func _ready() -> void:
	await super._ready()

	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")

	controller = Global.current_level.player_controller
	assert(controller != null, "PlayerController is null.")

# func on_update(_delta: float) -> void:
# 	var l: Label = player.get_node(^"CanvasLayer/Label")
# 	l.text = player.state_machine.state.name + '\n'
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


## Returns true if horizontal input is non-zero or the character is moving.
func check_for_moving() -> bool:
	return controller.get_horizontal_input() or character.is_moving()

## Returns true if the jump button is pressed and the character is landed.
func check_for_jumping(must_be_landed: bool = true) -> bool:
	return controller.get_jump_input() and (character.is_landed() if must_be_landed else true)

## Returns true if the player has a glomped body, or there is one in its vicinity.
func check_for_glomping() -> bool:
	return player.glomped_body or not player.get_glomped_bodies().is_empty()

## Returns true if the player is pressing the interact button.
func check_for_interacting() -> bool:
	return controller.get_interact_input()

## Returns true if the player is jumping while holding a glomped body.
func check_for_throwing() -> bool:
	return controller.get_jump_input() and player.glomped_body

## Returns true if the player is grabbing onto a wall, and there is a climbable wall nearby.
func check_for_climbing() -> bool:
	var bodies := player.get_climbable_bodies_in_proximity()

	if bodies.is_empty():
		return false

	var first := bodies[0]

	return character.is_on_wall() and not player.glomped_body

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
		await Global.create_timer(time).timeout

		# if we are still trying to swap and still not moving, we can swap
		return controller.get_horizontal_input() != 0 \
				and character.velocity.length() == 0

	return false

func check_for_auto_throw() -> bool:
	return player.glomped_body and player.glomped_body.has_meta(&"auto_throw") and character.velocity.y < 0

func check_for_ledge_grab() -> bool:
	var area: Area3D = player.ledge_grab_area
	return character.is_on_wall() and area.has_overlapping_areas()
	# return player.ledge_detector.is_on_ledge and character.is_on_wall()
