class_name PlayerGlompingState extends PlayerState

@onready var idle_state: State = $"../Idle"
@onready var jumping_state: State = $"../Jumping"

func on_enter(_previous_state: State, _data := {}) -> void:
	player.gravity_enabled = false
	player.move_enabled = false

	if not player.glomped_body:
		var bodies := player.get_glomped_bodies()
		print("Glomped bodies", bodies)

		if not bodies.is_empty():
			player.glomp_on(bodies[0])
		else:
			goto(idle_state)


func on_physics_update(_delta: float) -> void:
	if check_for_jumping():
		goto(jumping_state)
		# player.carry_glomped_body()
		#, {
		# 	&"air_move_speed": 100000.0,
		# 	&"air_accel_speed": 100000.0,
		# })

func on_exit() -> void:
	player.un_glomp()
