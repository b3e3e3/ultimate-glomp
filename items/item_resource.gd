class_name ItemResource extends Resource

@export var use_on_pickup: bool = false
@export var icon_texture: Texture2D
@export var display_name: String = "Item"
@export_range(1, 999) var max_stack: int = 99
@export_multiline var description: String = "An item"

@export var action: GameAction


func is_stackable() -> bool: return max_stack > 1

func use(character: Character) -> void:
	if not action: return
	action.execute(character)

func pick_up(character: Character) -> void:
	if use_on_pickup:
		use(character)
		return

	character.item_inventory.add_item(self)
