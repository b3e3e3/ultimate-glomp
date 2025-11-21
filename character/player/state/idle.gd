class_name PlayerIdleState extends PlayerState

@onready var moving_state: State = $"../Moving"
@onready var falling_state: State = $"../Falling"
@onready var jumping_state: State = $"../Jumping"
@onready var glomping_state: State = $"../Glomping"
@onready var attacking_state: State = $"../Attacking"
@onready var interacting_state: State = $"../Interacting"

func on_enter(_previous_state: State, data := {}) -> void:
	player.gravity_enabled = true
	player.move_enabled = true

	if data.get(&"reverse_coyote", false):
		data.erase(&"reverse_coyote")
		print("REVERSE COYOTE")
		goto(jumping_state)

func on_update(_delta: float) -> void:
	if check_for_interacting():
		goto(interacting_state)

func on_physics_update(_delta: float) -> void:
	if check_for_jumping():
		goto(jumping_state)
	elif check_for_glomping():
		goto(glomping_state)
	elif check_for_moving():
		goto(moving_state)
	elif check_for_falling():
		goto(falling_state)
	elif check_for_attacking():
		goto(attacking_state)

	super.on_physics_update(_delta)
