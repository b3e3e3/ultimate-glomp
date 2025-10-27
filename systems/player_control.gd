class_name PlayerControlSystem
extends System

func query() -> QueryBuilder:
	return q.with_all([C_CharacterBody, C_PlayerControl]).iterate([C_CharacterBody, C_PlayerControl])

func process(entities: Array[Entity], components: Array, _delta: float) -> void:
	var characters = components[0]
	var controls = components[1]

	for i in entities.size():
		var character: C_CharacterBody = characters[i]
		var control: C_PlayerControl = controls[i]

		if character.body:
			var _move := control.get_move_axis()
			var _jump := control.get_jump_axis()
			if _move or character.body.should_move():
				character.body.move(_move)

			if _jump:
				character.body.jump()
