@tool
class_name Player
extends Entity

func define_components() -> Array:
	return [
		C_PlayerControl.new(),
		C_CharacterBody.new(),
		C_GlompArea.new(),
	]

func on_ready():
	var c_char_body := get_component(C_CharacterBody)
	c_char_body.body = $CharacterBody

	var c_glomp_area := get_component(C_GlompArea)
	c_glomp_area.area = $CharacterBody/GlompArea
