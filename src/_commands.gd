extends Node

func _ready() -> void:
	LimboConsole.register_command(cmd_spawn, "spawn")
	LimboConsole.add_argument_autocomplete_source("spawn", 0,
		func(): return ["enemy",]
	)


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
