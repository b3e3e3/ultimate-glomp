class_name ItemResource extends Resource

@export var glompable: bool = true
@export var pickup_on_touch: bool = false
@export var use_on_pickup: bool = false
@export var consume_on_use: bool = false
@export var icon_texture: Texture2D
@export var display_name: String = "Item"
@export_range(1, 999) var max_stack: int = 99
@export_multiline var description: String = "An item"

@export var action: GameAction


func is_stackable() -> bool: return max_stack > 1
