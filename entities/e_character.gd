@tool
class_name Character
extends Entity

func on_ready():
	if has_component(C_CharacterBody):
		var c_char_body := get_component(C_CharacterBody)
		print("[%s] Found body at path %s" % [self.name, c_char_body.body_path], c_char_body.get_body(self))

	if has_component(C_GlompArea):
		var c_glomp_area := get_component(C_GlompArea)
		print("[%s] Found glomp area at %s" % [self.name, c_glomp_area.area_path], c_glomp_area.get_area(self))
