class_name GlompSystem
extends System

# func query() -> QueryBuilder:
# 	return q.with_all([C_GlompArea]).iterate([C_GlompArea])

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

		var area := c_area.get_area(entity)

		if not area:
			continue
		var char_bodies := area.get_overlapping_bodies()

		for other_body in char_bodies:
			var other := other_body.get_parent() as Entity
			var glomp_info := other.get_component(C_GlompInfo) as C_GlompInfo

			if not other:
				continue
			if entity.has_relationship(Relationships.is_glomping()):
				continue
			var body := c_body.get_body(entity)
			if not body:
				continue

			body.disable()

			entity.remove_component(C_PlayerControl)
			other.add_component(C_PlayerControl.new())

			body.reparent(other_body)
			body.global_position = glomp_info.get_glomp_point(other).global_position


func do_glomping(entities: Array[Entity], components: Array, _delta: float):
	for i in entities.size():
		var entity := entities[i]
		var c_control := components[0][i] as C_PlayerControl
		var c_body := components[1][i] as C_CharacterBody

		pass
