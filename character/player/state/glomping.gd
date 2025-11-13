class_name PlayerGlompingState extends PlayerState

@onready var idle_state: State = $"../Idle"
@onready var jumping_state: State = $"../Jumping"

var is_jumping := false


func on_enter(_previous_state: State, _data := {}) -> void:
	# print("Glomp state, has glomped body?", player.glomped_body)
	if player.glomped_body == null:
		var bodies := player.get_glomped_bodies()

		if not bodies.is_empty():
			player.glomp_on(bodies[0])
		else:
			goto(idle_state)

	player.velocity = Vector2.ZERO
	player.process_mode = PROCESS_MODE_DISABLED


func on_physics_update(_delta: float) -> void:
	if check_for_jumping():
		if player.glomped_body:
			goto(jumping_state,
			# {
			# 	&"air_move_speed": 100000.0,
			# 	&"air_accel_speed": 100000.0,
			# }
			)

	super.on_physics_update(_delta)

func on_exit() -> void:
	player.process_mode = PROCESS_MODE_INHERIT

	if not player.glomped_body.is_in_group(&"Throwable"):
		player.un_glomp()
