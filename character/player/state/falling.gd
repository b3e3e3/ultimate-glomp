class_name PlayerFallingState extends PlayerState

@onready var idle_state: State = $"../Idle"
@onready var glomping_state: State = $"../Glomping"
@onready var throwing_state: State = $"../Throwing"
@onready var jumping_state: State = $"../Jumping"
@onready var coyote_jumping_state: State = $"../CoyoteJumping"
@onready var climbing_state: State = $"../Climbing"
@onready var attacking_state: State = $"../Attacking"

@export var coyote_time: float = 0.2
@export var reverse_coyote_time: float = 0.2

var can_coyote: bool = true
var _can_reverse_coyote: bool = false

var climb_hopping: bool = false


func on_enter(_previous_state: State, data := {}) -> void:
	character.gravity_enabled = true
	character.move_enabled = true

	can_coyote = not data.get(&'just_jumped') if data.has(&'just_jumped') else true
	_can_reverse_coyote = false
	climb_hopping = data.get(&'just_climbed', false)

	character.remaining_jumps = data.get(&'jumps', 0)

	if can_coyote:
		# disable coyote timer after <coyote_time> seconds
		var ct: float = data.get(&'coyote_time', coyote_time)

		get_tree().create_timer(ct).timeout.connect(func():
			# prevent this timer from firing if the player lands before the timer expires
			if not character.is_on_floor() or not character.is_on_wall():
				can_coyote = false
		, CONNECT_ONE_SHOT)

func on_physics_update(delta: float) -> void:
	super.on_physics_update(delta)

	var _speed = character.get_speed()
	var _accel = character.get_accel_speed()
	var _decel = character.get_decel_speed()

	var hor := controller.get_horizontal_input()

	if check_for_landing():
		goto(idle_state, {
			&"reverse_coyote": _can_reverse_coyote
		})
	elif check_for_attacking() and not check_for_glomping():
		goto(attacking_state)
	elif check_for_climbing():
		goto(climbing_state)

	elif check_for_throwing():
		goto(throwing_state)

	elif controller.get_jump_input():
		if can_coyote:
			goto(coyote_jumping_state)

		elif character.remaining_jumps > 0:
			goto(jumping_state)

		elif not _can_reverse_coyote:
			_can_reverse_coyote = true
			get_tree().create_timer(reverse_coyote_time).timeout.connect(func():
				_can_reverse_coyote = false
			, CONNECT_ONE_SHOT)

	elif check_for_moving_horizontal():
		# for some reason, this makes us jump way too far when jumping off from climbing
		# without holding a direction down
		if hor != 0:
			player.horizontal_move(hor, character.get_speed(), _accel, _decel)
