class_name MultiAction extends GameAction

@export var actions: Array[GameAction]


func initialize(owner: Node3D):
	for a in actions:
		a.initialize(owner)

func on_start(character: Character = null):
	for a in actions:
		a.start(character)
