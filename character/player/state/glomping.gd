class_name PlayerGlompingState extends PlayerState

@onready var idle_state: State = $"../Idle"
@onready var jumping_state: State = $"../Jumping"

func on_enter(_previous_state: State, _data := {}) -> void:
	var bodies := player.get_glomped_bodies()
	print("Glomped bodies", bodies)

	if bodies.is_empty():
		goto(idle_state)
	else:
		var body := bodies[0] as PhysicsBody2D
		player.glomp_on(body)

func on_physics_update(_delta: float) -> void:
	if check_for_jumping():
		goto(jumping_state)
		#, {
		# 	&"air_move_speed": 100000.0,
		# 	&"air_accel_speed": 100000.0,
		# })

func on_exit() -> void:
	player.un_glomp()
