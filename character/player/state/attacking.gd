class_name PlayerAttackingState extends PlayerState

func on_enter(previous_state: State, _data := {}) -> void:
	player.attack()
	goto(previous_state)
