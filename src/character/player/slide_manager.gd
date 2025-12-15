extends Node

@export var delay_time := 0.05

@export var _should_slide := false
var should_slide: bool:
	get:
		return _should_slide
	set(value):
		_should_slide = value
		print("Should slide? ", value)
		if value == false:
			await Global.create_timer(delay_time).timeout
			_should_slide = true
