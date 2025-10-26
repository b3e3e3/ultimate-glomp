class_name MovementSystem
extends System

func query() -> QueryBuilder:
	print("Q")
	return q.with_all([C_CharacterBody, C_PlayerControl])

func process(entity: Entity, delta: float) -> void:
	var character := entity.get_component(C_CharacterBody) as C_CharacterBody
	var control := entity.get_component(C_PlayerControl) as C_PlayerControl

	var _move := control.get_move_axis()
	var _jump := control.get_jump_axis()

	if _move or character.body.should_move():
		character.body.move(_move)

	if _jump:
		character.body.jump()
