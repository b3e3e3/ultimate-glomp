class_name PlayerFallingState extends PlayerState

@onready var idle_state: State = $"../Idle"
@onready var glomping_state: State = $"../Glomping"
@onready var throwing_state: State = $"../Throwing"
@onready var jumping_state: State = $"../Jumping"

@export var air_move_speed: float = 300.0
@export var air_accel_speed: float = 15.0
@export var coyote_time: float = 0.2

var _speed: float
var _accel: float

var can_coyote: bool = true

func on_enter(_previous_state: State, data := {}) -> void:
	character.gravity_enabled = true
	character.move_enabled = true

	can_coyote = not data.get(&'just_jumped') if data.has(&'just_jumped') else true

	_speed = data.get(&"air_move_speed") if data.has(&"air_move_speed") else air_move_speed
	_accel = data.get(&"air_accel_speed") if data.has(&"air_accel_speed") else air_accel_speed

	if can_coyote:
		# disable coyote timer after <coyote_time> seconds
		get_tree().create_timer(coyote_time).timeout.connect(func():
			print("Can't coyote anymore")
			can_coyote = false
		, CONNECT_ONE_SHOT)

func on_physics_update(_delta: float) -> void:
	var hor := controller.get_horizontal_input()

	if check_for_landing():
		goto(idle_state)
	elif controller.get_jump_input() and can_coyote:
		print('Coyote jump!')
		goto(jumping_state)
	elif check_for_throwing():
		goto(throwing_state)
	elif check_for_moving():
		character.move(hor, _accel, _speed)
