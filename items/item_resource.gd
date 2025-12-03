class_name ItemResource extends Resource

@export var icon_texture: Texture2D
@export var display_name: String = "Item"
@export_range(1, 999) var max_stack: int = 99
@export_multiline var description: String = "An item"

@export var action: ItemAction


func is_stackable() -> bool: return max_stack > 1
func use(character: Character) -> void:
	action.execute(character)
