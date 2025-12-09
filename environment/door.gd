extends Node3D

enum DoorState {
	CLOSED,
	OPEN,
}

@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var state: DoorState = DoorState.CLOSED


func _ready() -> void:
	match state:
		DoorState.CLOSED:
			anim_player.play(&"close")
		DoorState.OPEN:
			anim_player.play(&"open")
	anim_player.seek(anim_player.current_animation_length)

func open() -> void:
	if state == DoorState.OPEN: return

	state = DoorState.OPEN
	anim_player.play(&"open")

func close() -> void:
	if state == DoorState.CLOSED: return

	state = DoorState.CLOSED
	anim_player.play(&"close")

func toggle_open() -> void:
	call(&"open" if state == DoorState.CLOSED else &"close")
