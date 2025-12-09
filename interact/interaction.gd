class_name Interaction extends Resource

signal started
signal stepped
signal finished
signal updated

@export var item_guards: Array[ItemResource]
@export var flag_guards: Array[StringName]
@export var guard_success_action: GameAction
@export var guard_failure_action: GameAction

func start() -> void:
	var player := Global.current_level.player

	for item in item_guards:
		if not item in player.item_inventory.items:
			print("PLAYER DOES NOT HAVE", item.display_name, "!")
			if guard_failure_action:
				guard_failure_action.execute(player)
			finish()
			return
		else:
			if guard_success_action:
				guard_success_action.execute(player)
			item.use(player)

	for item in flag_guards:
		continue # TODO: flag guards

	on_start()
	started.emit()

func step() -> void:
	on_step()
	stepped.emit()

func update(delta: float) -> void:
	on_update(delta)
	updated.emit()

func finish() -> void:
	on_finish()
	finished.emit()


func on_start() -> void: step()
func on_step() -> void: finish()
func on_update(_delta: float) -> void: pass
func on_finish() -> void: pass

func initialize(_owner: Node3D): pass
