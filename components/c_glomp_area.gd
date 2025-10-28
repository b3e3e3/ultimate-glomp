class_name C_GlompArea
extends Component

@export_node_path("Area2D") var area_path: NodePath
var _area: Area2D

func get_area(entity: Entity) -> Area2D:
	if not _area:
		_area = entity.get_node(area_path)
	return _area
