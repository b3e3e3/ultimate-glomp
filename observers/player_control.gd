class_name PlayerControlObserver
extends Observer

func watch() -> Resource:
	return C_PlayerControl

func on_component_added(entity: Entity, component: Resource) -> void:
	pass

func on_component_removed(entity: Entity, component: Resource) -> void:
	pass
