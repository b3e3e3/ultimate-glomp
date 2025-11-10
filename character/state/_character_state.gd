class_name CharacterState extends State
var character: Character

func _ready() -> void:
	await owner.ready
	character = owner as Character
	assert(character != null, "The CharacterState state type must be used only in the character scene. It needs the owner to be a Character node.")


func check_for_falling() -> bool:
	return not character.is_on_floor()

func check_for_landing() -> bool:
	return character.is_on_floor() or character.is_landed()
