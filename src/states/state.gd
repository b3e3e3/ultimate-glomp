class_name State extends Node

signal finished(next_state: State, data: Dictionary[StringName, Variant])

func on_handle_input(_event: InputEvent) -> void: pass

func on_update(_delta: float) -> void: pass
func on_physics_update(_delta: float) -> void: pass

func on_enter(previous_state: State, data := {}) -> void: pass

func on_exit() -> void: pass

func goto(next_state: State, data := {}) -> void:
	finished.emit(next_state, data)
