class_name WaitForSignalInteraction extends Interaction

@export var signal_to_await: StringName
@export var target_path: NodePath
@export var timeout: float = 1.0

var owner: Node3D
var complete: bool = false

var target: Node

func initialize(interaction_owner: Node3D):
	owner = interaction_owner
	assert(owner)

	target = owner.get_node(target_path)
	assert(target)
	assert(target.has_signal(signal_to_await))


func on_step(): pass

func on_start():
	complete = false

	target.connect(signal_to_await, func():
		complete = true
		finish()
		print("YAYYAYAYAY")
		, CONNECT_ONE_SHOT)

	await owner.get_tree().create_timer(timeout).timeout

	if not complete:
		print("Wait for signal interaction timed out.")
		finish()
