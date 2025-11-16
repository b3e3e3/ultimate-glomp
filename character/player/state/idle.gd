class_name PlayerIdleState extends PlayerState

@onready var moving_state: State = $"../Moving"
@onready var falling_state: State = $"../Falling"
@onready var jumping_state: State = $"../Jumping"
@onready var glomping_state: State = $"../Glomping"
@onready var attacking_state: State = $"../Attacking"

func on_enter(_previous_state: State, data := {}) -> void:
	player.gravity_enabled = true
	player.move_enabled = true

	if check_for_glomping():
		player.combo_jump.reset()
		player.combo_jump.cancel_timer()

	if _previous_state:
		if player.combo_jump.progress() and player.combo_jump.is_comboing():
				$"../../GPUParticles3D".emitting = true
				$"../../GPUParticles3D".amount_ratio = (player.combo_jump.current_combo / 3.0)
				$"../../GPUParticles3D".process_mode = PROCESS_MODE_ALWAYS

	if data.get(&"reverse_coyote", false):
		data.erase(&"reverse_coyote")
		print("REVERSE COYOTE")
		goto(jumping_state)

func on_physics_update(_delta: float) -> void:
	if check_for_jumping():
		goto(jumping_state)
	elif check_for_glomping():
		goto(glomping_state)
	elif check_for_moving_horizontal():
		goto(moving_state)
	elif check_for_falling():
		goto(falling_state)
	elif check_for_attacking():
		goto(attacking_state)

	super.on_physics_update(_delta)


func _on_player_glomped(_body: PhysicsBody3D) -> void:
	player.combo_jump.reset()
