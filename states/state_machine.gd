class_name StateMachine extends Node

@export var initial_state: State
@onready var state: State = (func() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()

func _ready() -> void:
	# Give every state a reference to the state machine.
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(__transition_to_next_state)

	# State machines usually access data from the root node of the scene they're part of: the owner.
	# We wait for the owner to be ready to guarantee all the data and nodes the states may need are available.
	await owner.ready
	state.on_enter(null)

func _unhandled_input(event: InputEvent) -> void:
	state.on_handle_input(event)

func _process(delta: float) -> void:
	state.on_update(delta)

func _physics_process(delta: float) -> void:
	state.on_physics_update(delta)

func __transition_to_next_state(target_state: State, data: Dictionary = {}) -> void:
	assert(target_state != null, owner.name + ": Trying to transition to state " + target_state.name + " but it does not exist.")
	print("Going from state " + state.name + " to state " + target_state.name)
	var previous_state := state
	state.on_exit()
	state = target_state
	state.on_enter(previous_state, data)
