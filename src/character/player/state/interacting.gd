class_name PlayerInteractingState extends PlayerState

@export var interact_area: InteractArea

@onready var idle_state: State = $"../Idle"


func on_enter(_previous_state: State, _data := {}) -> void:
	interact_area.started.connect(_on_interaction_started)
	interact_area.finished.connect(_on_interaction_finished)
	interact_area.stepped.connect(_on_interaction_stepped)

	interact_area.find_and_start_interaction()
	if not interact_area.current_interaction:
		print("No interaction found")
		goto(idle_state)

	character.move_enabled = false
	character.gravity_enabled = false

func on_exit() -> void:
	interact_area.started.disconnect(_on_interaction_started)
	interact_area.finished.disconnect(_on_interaction_finished)
	interact_area.stepped.disconnect(_on_interaction_stepped)

func on_update(_delta: float) -> void:
	if check_for_interacting() and interact_area.current_interaction:
		interact_area.step.call_deferred()


func _on_interaction_started(_interaction: GameAction):
	pass

func _on_interaction_finished(_interaction: GameAction):
	goto(idle_state)

func _on_interaction_stepped(_interaction: GameAction):
	pass
