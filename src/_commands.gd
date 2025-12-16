extends Node

const TELEPORTS_PATH: String = "user://debug_teleports.dat"

var teleports: Dictionary[String, Vector3] = {}

@onready var item_list: Array[String] = []


func _load_saved_teleports() -> Dictionary[String, Vector3]:
	if FileAccess.file_exists(TELEPORTS_PATH):
		var file = FileAccess.open(TELEPORTS_PATH, FileAccess.READ_WRITE)
		var val = file.get_var()
		if val:
			return Dictionary(val as Dictionary, TYPE_STRING, "", null, TYPE_VECTOR3, "", null)
	return {}

func _ready() -> void:
	# load items list
	var dir := DirAccess.open("res://items")
	dir.list_dir_begin()

	for item_name in dir.get_files():
		if item_name.ends_with(".tres"):
			item_list.append(item_name.split(".")[0])

	dir.list_dir_end()

	# load saved teleports
	teleports = _load_saved_teleports()

	# spawn
	LimboConsole.register_command(cmd_spawn, "spawn")
	LimboConsole.add_argument_autocomplete_source("spawn", 0,
		func(): return ["enemy",]
	)

	# flags
	LimboConsole.register_command(cmd_flag_set, "flag set")
	LimboConsole.add_argument_autocomplete_source("flag set", 1,
		func(): return ["true", "false"]
	)
	LimboConsole.add_argument_autocomplete_source("flag set", 2,
		func(): return ["global", "local", "level"]
	)

	# teleport
	LimboConsole.register_command(cmd_teleport, "teleport to")
	LimboConsole.add_argument_autocomplete_source("teleport to", 0,
		func(): return teleports.values()
	)

	LimboConsole.register_command(cmd_teleport_set, "teleport set")
	LimboConsole.add_argument_autocomplete_source("teleport set", 1,
		func(): return ["true", "false"]
	)

	LimboConsole.register_command(cmd_teleport_delete, "teleport delete")
	LimboConsole.add_argument_autocomplete_source("teleport delete", 0,
		func(): return teleports.keys()
	)

	LimboConsole.register_command(cmd_teleport_list, "teleport list")

	# items
	LimboConsole.register_command(cmd_item_give, "item give")
	LimboConsole.add_argument_autocomplete_source("item give", 0,
		func(): return item_list
	)

	LimboConsole.register_command(cmd_item_give, "item remove")
	LimboConsole.add_argument_autocomplete_source("item remove", 0,
		func(): return item_list
	)

	LimboConsole.register_command(cmd_item_list_inventory, "item list inventory")
	LimboConsole.register_command(cmd_item_list_all, "item list all")

# spawn

func cmd_spawn(what: String, x: float = 5, y: float = 5.0) -> void:
	match what:
		"enemy":
			var enemy: PackedScene = preload("res://character/enemy/enemy.tscn")
			var e: Node3D = enemy.instantiate()
			e.position = Vector3(x, y, 0.0)
			Global.current_level.add_child(e)
		_:
			LimboConsole.error("Invalid argument")
			return

	LimboConsole.info("Spawning %s at %s, %s, %s" % [what, x, y, 0.0])

# flags

func cmd_flag_set(flag_name: String, value: bool, scope: String = "global") -> void:
	match scope.to_lower():
		"global":
			Global.Flags.set_flag(flag_name, value)
		"local", "level":
			Global.current_level.Flags.set_flag(flag_name, value)
		_:
			LimboConsole.error("Invalid scope")
			LimboConsole.info("Setting %s flag \"$s\" to \"%s\"" % [scope, flag_name, value])

# teleports

func cmd_teleport(tp_name: String) -> void:
	if not teleports.has(tp_name):
		LimboConsole.error("Teleport \"%s\" not found" % tp_name)
		return

	Global.current_level.player.global_position = teleports[tp_name]
	LimboConsole.info("Teleporting to \"%s\"" % tp_name)

func cmd_teleport_set(tp_name: String, save: bool = false) -> void:
	teleports.set(tp_name, Global.current_level.player.global_position)
	LimboConsole.info("Teleport \"%s\" set to %s" % [tp_name, teleports[tp_name]])

	if save:
		var file = FileAccess.open(TELEPORTS_PATH, FileAccess.WRITE_READ)
		var err := FileAccess.get_open_error()
		if err:
			LimboConsole.error("Failed to open file: %s" % err)
			return
		var saved_teleports: Dictionary = _load_saved_teleports()

		saved_teleports.set(tp_name, Global.current_level.player.global_position)
		file.store_var(saved_teleports)

		LimboConsole.info("Saved teleport to %s" % file.get_path_absolute())
		file.close()

func cmd_teleport_delete(tp_name: String) -> void:
	if not teleports.has(tp_name):
		LimboConsole.error("Teleport \"%s\" not found" % tp_name)
		return

	var saved_teleports := _load_saved_teleports()
	if saved_teleports.has(tp_name):
		saved_teleports.erase(tp_name)
		var file = FileAccess.open(TELEPORTS_PATH, FileAccess.WRITE)
		file.store_var(saved_teleports)
		file.close()

	teleports.erase(tp_name)
	LimboConsole.info("Deleted teleport \"%s\"" % tp_name)

func cmd_teleport_list() -> void:
	var locs := teleports.keys().map(func (e):
		return "%s: %s" % [e, teleports[e]]
	)
	LimboConsole.info("Teleports:\n%s" % "\n".join(locs))

# items

func cmd_item_give(item_name: String, amount: int = 1) -> void:
	var player := Global.current_level.player
	var path := "res://items/%s.tres" % item_name

	if item_name in item_list:
		var res = load(path)
		if res is ItemResource:
			LimboConsole.info("Giving %s %s to player" % [item_name, amount])
			for i in range(amount):
				player.item_inventory.add_item_resource(res.duplicate())
			return

	LimboConsole.error("Item \"%s\" not found" % item_name)

func cmd_item_remove(item_name: String, amount: int = 1) -> void:
	var player := Global.current_level.player

	if not item_name in item_list:
		LimboConsole.error("Item \"%s\" not found" % item_name)
		return

	if not player.item_inventory.has_item(item_name):
		LimboConsole.error("Item \"%s\" not found in player inventory" % item_name)
		return

	LimboConsole.info("Removing %s %s from player" % [item_name, amount])
	for i in range(amount):
		player.item_inventory.remove_item(item_name)
		return

func cmd_item_list_inventory() -> void:
	var items := Global.current_level.player.item_inventory.items.keys().map(func (e):
		return "%s" % [e.display_name, ]
	)
	LimboConsole.info("Items: %s" % ", ".join(items))

func cmd_item_list_all() -> void:
	LimboConsole.info("Items:\n%s" % ", ".join(item_list))
