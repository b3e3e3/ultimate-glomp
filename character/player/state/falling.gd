class_name PlayerFallingState extends PlayerState

@onready var idle_state: State = $"../Idle"
@onready var glomping_state: State = $"../Glomping"

@export var air_move_speed: float = 300.0
@export var air_accel_speed: float = 15.0

var _speed: float
var _accel: float

func on_enter(_previous_state: State, data := {}) -> void:
	player.gravity_enabled = true
	player.move_enabled = true

	if data and data.has(&"air_move_speed"):
		_speed = data.get(&"air_move_speed")
	else:
		_speed = air_move_speed

	if data and data.has(&"air_accel_speed"):
		_accel = data.get(&"air_accel_speed")
	else:
		_accel = air_accel_speed

func on_physics_update(_delta: float) -> void:
	var hor := controller.get_horizontal_input()

	if check_for_landing():
		goto(idle_state)
	elif check_for_moving():
		player.move(hor, _accel, _speed)
