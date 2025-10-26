class_name GlompSystem
extends System

var r := Relationship.new(C_IsGlomped.new())

func query() -> QueryBuilder:
	return q.with_relationship([r])

func process(entities: Array[Entity], components: Array, delta: float) -> void:
	print(entities)
	if components.is_empty(): return#entities.is_empty(): return
	print(entities[0].has_relationship(r))

	var glomps = components[0]

	for i in entities.size():
		var entity := entities[i]
		var glomp: C_IsGlomped = glomps[i]

		entity.get_relationship(r)
