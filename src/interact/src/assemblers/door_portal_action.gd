class_name DoorPortalAction extends MultiAction

@export var level_path: StringName
@export var signal_to_await: StringName = &"finished"
@export var anim_name: StringName = &"enter_door"


func on_start(character: Character, owner: Node):
	var wfs := WaitForSignalAction.new()
	wfs.signal_to_await = signal_to_await
	actions.append(wfs)

	var aa := AnimationAction.new()
	aa.anim_name = anim_name
	actions.append(aa)

	var pa := PortalAction.new()
	pa.level_path = level_path
	actions.append(pa)

	super.on_start(character, owner)
