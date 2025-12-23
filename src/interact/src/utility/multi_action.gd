class_name MultiAction extends GameAction

@export var actions: Array[GameAction]

var aidx := 0


func start_next_action(_success: bool, character: Character, owner: Node):
	var f := func(__success: bool):
		if aidx < actions.size() - 1:
			aidx += 1
			start_next_action(__success, character, owner)
		else:
			finish(true)

	if actions[aidx].finished.is_connected(f):
		actions[aidx].finished.disconnect(f)

	print("Performin action #",aidx)
	actions[aidx].finished.connect(f)
	actions[aidx].start(character, owner)

func on_start(character: Character, owner: Node):
	start_next_action(true, character, owner)
