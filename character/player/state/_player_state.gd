class_name PlayerState extends CharacterState
var player: Player


func _ready() -> void:
	await super._ready()

	player = character as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")


func check_for_moving() -> bool:
	return character.get_horizontal_input() or character.velocity.x != 0

func check_for_jumping() -> bool:
	return character.get_jump_input() and character.can_jump()

func check_for_glomping() -> bool:
	return not player.get_glomped_bodies().is_empty()
