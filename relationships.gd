extends Node

func is_glomping(by = null) -> Relationship:
	return Relationship.new(C_IsGlomped.new(), by)
