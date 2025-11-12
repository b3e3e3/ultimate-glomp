class_name PlayerIdleState extends PlayerState

@onready var moving_state: State = $"../Moving"
@onready var falling_state: State = $"../Falling"
@onready var jumping_state: State = $"../Jumping"
@onready var glomping_state: State = $"../Glomping"
@onready var attacking_state: State = $"../Attacking"

func on_enter(_previous_state: State, _data := {}) -> void:
	player.gravity_enabled = true
	player.move_enabled = true

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
		goto(jumping_state)

	super.on_physics_update(_delta)
