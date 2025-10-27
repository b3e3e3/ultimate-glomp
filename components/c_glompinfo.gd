class_name C_GlompInfo
extends Component

@export_node_path("Node2D") var glomp_point_path: NodePath

func get_glomp_point(root: Node) -> Node2D:
	return root.get_node(glomp_point_path)
