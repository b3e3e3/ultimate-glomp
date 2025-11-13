class_name PlayerIdleState extends PlayerState

@onready var moving_state: State = $"../Moving"
@onready var falling_state: State = $"../Falling"
@onready var jumping_state: State = $"../Jumping"
@onready var glomping_state: State = $"../Glomping"
@onready var attacking_state: State = $"../Attacking"

@export var triangle_jump_time: float = 0.1
@export var triangle_jump_limit: int = 3
var _triangle_combo: int = 0

func on_enter(_previous_state: State, data := {}) -> void:
	player.gravity_enabled = true
	player.move_enabled = true

	_triangle_combo = data.get(&"triangle_combo", _triangle_combo)
	if _triangle_combo < triangle_jump_limit and _previous_state:
		_triangle_combo += 1
	else:
		_triangle_combo = 0

	data.set(&"triangle_combo", _triangle_combo)

	get_tree().create_timer(triangle_jump_time).timeout.connect(func():
		if get_parent().state == falling_state: return
		if get_parent().state == jumping_state: return
		_triangle_combo = 0
		data.erase(&"triangle_combo")
	, CONNECT_ONE_SHOT)

	if data.get(&"reverse_coyote", false):
		data.erase(&"reverse_coyote")
		print("REVERSE COYOTE")
		__do_jump()

func __do_jump():
	var data := {}

	if _triangle_combo:
		data.set(&'triangle_combo', _triangle_combo)

	goto(jumping_state, data)

func on_physics_update(_delta: float) -> void:
	if check_for_moving_horizontal():
		goto(moving_state)
	elif check_for_falling():
		goto(falling_state)
	elif check_for_attacking():
		goto(attacking_state)
	elif check_for_glomping():
		goto(glomping_state)
	elif check_for_jumping():
		__do_jump()

	super.on_physics_update(_delta)


func _on_player_glomped(_body: PhysicsBody2D) -> void:
	_triangle_combo = 0
