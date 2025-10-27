class_name C_CharacterBody
extends Component

var body: CharacterBody

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var is_frozen: bool:
	get:
		return body != null and body.is_frozen
	set(value):
		if body:
			body.is_frozen = value
		else:
			push_warning("Cannot set frozen state on null body")

func toggle_freeze():
	is_frozen = !is_frozen

func _init(_speed: float = speed, _jump_velocity: float = jump_velocity):
	_speed = _speed
	_jump_velocity = _jump_velocity
