class_name PlayerControlSystem
extends System

func query() -> QueryBuilder:
	return q.with_all([C_CharacterBody, C_PlayerControl]).iterate([C_CharacterBody, C_PlayerControl])

func process(entities: Array[Entity], components: Array, _delta: float) -> void:
	var characters = components[0]
	var controls = components[1]

	for i in entities.size():
		var entity := entities[i]
		var character: C_CharacterBody = characters[i]
		var control: C_PlayerControl = controls[i]

		var body := character.get_body(entity)

		if body and not character.is_frozen:
			var _move := control.get_move_axis()
			var _jump := control.get_jump_pressed()
			if _move or body.should_move():
				body.move(_move)
			if _jump:
				body.jump()
