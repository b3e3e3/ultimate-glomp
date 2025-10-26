@tool
class_name Player
extends Entity

var _body: CharacterBody

func define_components() -> Array:
	return [
		C_CharacterBody.new(),
		C_PlayerControl.new(),
	]


func _init(character_body: CharacterBody):
	_body = character_body

func on_ready() -> void:
	var c_body := self.get_component(C_CharacterBody)
	c_body.body = _body
	_body = null
