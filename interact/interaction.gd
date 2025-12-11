class_name Interaction extends Resource

signal started
signal stepped
signal finished(success: bool)
signal updated

var _start_count: int = 0

@export var one_shot: bool = false
@export var item_guards: Array[ItemResource]
@export var flag_guards: Array[StringName]
@export var guard_success_action: GameAction
@export var guard_failure_action: GameAction

func start() -> void:
	if one_shot and _start_count > 0:
		finish(false)
		return

	var player := Global.current_level.player

	for item in item_guards:
		if not item in player.item_inventory.items:
			print("PLAYER DOES NOT HAVE", item.display_name, "!")
			if guard_failure_action:
				guard_failure_action.execute(player)
			finish(false)
			return
		else:
			if guard_success_action:
				guard_success_action.execute(player)
			item.use(player)

	for item in flag_guards:
		continue # TODO: flag guards

	on_start()
	started.emit()

	_start_count += 1

func step() -> void:
	on_step()
	stepped.emit()

func update(delta: float) -> void:
	on_update(delta)
	updated.emit()

func finish(success: bool = true) -> void:
	on_finish(success)
	finished.emit(success)


func on_start() -> void: step()
func on_step() -> void: finish()
func on_update(_delta: float) -> void: pass
func on_finish(_success: bool) -> void: pass

func initialize(_owner: Node3D): pass
