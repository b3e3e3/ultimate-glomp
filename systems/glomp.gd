class_name GlompSystem
extends System

func query() -> QueryBuilder:
	return q.with_all([C_GlompArea])

func process(entities: Array[Entity], components: Array, delta: float) -> void:
	if entities.is_empty(): return
	return

# 	for i in entities.size():
# 		var entity := entities[i]
# 		var glomp := entity.get_relationship(r)

# 		var source: Entity = glomp.source
# 		var target: Entity = glomp.target

# 		assert(source, "Glomp relationship is missing source entity")
# 		assert(target, "Glomp relationship is missing target entity")

# 		entity.get_relationship(r)
