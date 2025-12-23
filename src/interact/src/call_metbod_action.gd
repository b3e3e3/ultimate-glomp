class_name CallMethodAction extends GameAction

@export_node_path var target_path: NodePath
@export var target_method: StringName


func on_start(_character: Character, _owner: Node) -> void:
	var node = _owner.get_node(target_path)

	if node.has_method(target_method):
		node.call(target_method)
		finish(true)
	else:
		print("Method not found")
		finish(false)
