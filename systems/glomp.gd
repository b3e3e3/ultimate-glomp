class_name GlompSystem
extends System

func query() -> QueryBuilder:
	return q.with_all([C_GlompArea]).iterate([C_GlompArea])

func sub_systems():
	return [
		# [query, callable] - all use same unified process signature
		[
			q
			.without_relationship([Relationships.is_glomping()])
			.with_all([C_GlompArea, C_CharacterBody])
			.iterate([C_GlompArea, C_CharacterBody])
			, monitor_glomp_areas
		],
		[
			q
			.with_relationship([Relationships.is_glomping()])
			.with_all([C_PlayerControl, C_CharacterBody])
			.iterate([C_PlayerControl, C_CharacterBody])
			, do_glomping
		]
	]

func monitor_glomp_areas(entities: Array[Entity], components: Array, _delta: float) -> void:
	var areas: Array = components[0]
	var bodies: Array = components[1]

	for i in entities.size():
		var entity := entities[i]
		var c_area: C_GlompArea = areas[i]
		var c_body: C_CharacterBody = bodies[i]

		var char_bodies := c_area.area.get_overlapping_bodies()

		for body in char_bodies:
			var other := body.get_parent() as Entity

			if not other:
				continue
			if entity.has_relationship(Relationships.is_glomping()):
				continue

			# glomp
			c_body.body.disable()

			if other.has_component(C_GlompInfo):
				var c_info := other.get_component(C_GlompInfo) as C_GlompInfo
				var glomp_point := c_info.get_glomp_point(other)

				entity.reparent(glomp_point)

				c_body.body.global_position = glomp_point.global_position

			entity.add_relationship(Relationships.is_glomping(other))

			print(entity.get_relationship(Relationships.is_glomping(other)).source)
			print(entity.get_relationship(Relationships.is_glomping(other)).target)

func do_glomping(entities: Array[Entity], components: Array, _delta: float):
	for i in entities.size():
		var entity := entities[i]
		var c_control := components[0][i] as C_PlayerControl
		var c_body := components[1][i] as C_CharacterBody

		var is_glomping := entity.get_relationship(Relationships.is_glomping())
		var other: Entity = is_glomping.target

		if not other:
			continue

		if c_control.get_jump_pressed():
			# unglomp
			if other.has_component(C_GlompInfo):
				entity.reparent(other.get_parent())

			c_body.body.enable()

			await get_tree().create_timer(0.5).timeout

			entity.remove_relationship(Relationships.is_glomping())
			print("Unglomped (relationship removed)")
