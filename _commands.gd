extends Node

func _ready() -> void:
	LimboConsole.register_command(cmd_spawn, "spawn")
	LimboConsole.add_argument_autocomplete_source("spawn", 0,
		func(): return ["enemy",]
	)


func cmd_spawn(what: String, x: float = 500, y: float = 0.0) -> void:
	match what:
		"enemy":
			var enemy: PackedScene = load("res://character/enemy/enemy.tscn")
			var e: Node2D = enemy.instantiate()
			e.position = Vector2(x, y)
			Global.current_level.add_child(e)
		_:
			LimboConsole.error("Invalid argument")
			return

	LimboConsole.info("Spawning %s at %s, %s" % [what, x, y])
