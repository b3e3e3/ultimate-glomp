class_name WaitForSignalAction extends GameAction

@export var signal_to_await: StringName
@export var timeout: float = 1.0
@export var on_signal: GameAction

var owner: Node3D
var complete: bool = false

func initialize(interaction_owner: Node3D):
	owner = interaction_owner.get_parent()

	assert(owner)
	assert(owner.has_signal(signal_to_await))

	print("%s has %s? %s" % [owner, signal_to_await, owner.has_signal(signal_to_await)])

	on_signal.initialize(interaction_owner)

	if not on_signal.finished.is_connected(finish):
		on_signal.finished.connect(finish)
		print("Connected")


func on_step(): pass

func on_start(_character: Character = null):
	complete = false
	print("Startine..", owner)

	var f := func():
		complete = true
		on_signal.start(current_character)
		print("YAYYAYAYAY")

	owner.connect(signal_to_await, f, CONNECT_ONE_SHOT)

	await owner.get_tree().create_timer(timeout).timeout

	if not complete:
		print("Wait for signal interaction timed out.")
		owner.disconnect(signal_to_await, f)
		finish(false)

func on_finish(_success: bool) -> void:
	print("On signal succeeded? ", _success)
