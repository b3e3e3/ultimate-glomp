class_name WaitForSignalAction extends GameAction

@export var signal_to_await: StringName
@export var target_path: NodePath
@export var timeout: float = 1.0
@export var on_signal: GameAction

var owner: Node3D
var complete: bool = false

var target: Node

func initialize(interaction_owner: Node3D):
	owner = interaction_owner
	assert(owner)

	target = owner.get_node(target_path)
	assert(target)
	assert(target.has_signal(signal_to_await))

	if not on_signal.finished.is_connected(finish):
		on_signal.finished.connect(finish)


func on_step(): pass

func on_start(_character: Character = null):
	complete = false

	target.connect(signal_to_await, func():
		complete = true
		on_signal.start(current_character)
		print("YAYYAYAYAY")
		, CONNECT_ONE_SHOT)

	await owner.get_tree().create_timer(timeout).timeout

	if not complete:
		print("Wait for signal interaction timed out.")
		finish(false)

func on_finish(_success: bool) -> void:
	print("On signal succeeded? ", _success)
