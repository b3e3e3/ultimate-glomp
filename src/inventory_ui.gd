extends Control

# TODO: menu UI class
signal opened
signal closed

@onready var item_list: ItemList = $"TabContainer/Item/ItemList"

var items: Array[ItemResource] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opened.connect(_on_inventory_opened)
	closed.connect(_on_inventory_closed)
	visible = false

func _on_inventory_opened():
	print("inventory opened")

	# load items
	item_list.clear()
	items.clear()

	for item in Global.current_level.player.item_inventory.items:
		item_list.add_item(item.display_name, item.icon_texture)
		items.append(item)

func _on_inventory_closed():
	print("inventory closed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"ui_cancel"):
		toggle_open()


func _on_item_list_item_selected(index: int) -> void:
	var res := items[index]
	var player := Global.current_level.player

	player.item_inventory.items[res].use(player)

func toggle_open() -> void:
	visible = !visible
	(opened if visible else closed).emit()
