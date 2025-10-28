class_name C_CharacterBody
extends Component

@export_node_path("CharacterBody") var body_path: NodePath
var _body: CharacterBody

func get_body(entity: Entity) -> CharacterBody:
	if not _body:
		_body = entity.get_node(body_path)
	return _body

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var is_frozen: bool:
	get:
		return _body != null and _body.is_frozen
	set(value):
		if _body:
			_body.is_frozen = value
		else:
			push_warning("Cannot set frozen state on null body")

func toggle_freeze():
	is_frozen = !is_frozen

func _init(_speed: float = speed, _jump_velocity: float = jump_velocity):
	_speed = _speed
	_jump_velocity = _jump_velocity
