extends Node3D

signal finished

enum DoorState {
	CLOSED,
	OPEN,
}

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var interaction: Interaction = load("res://interact/interactions/" + interaction_name + ".tres")

@export var interaction_name: String = "default"
@export var state: DoorState = DoorState.CLOSED


func _ready() -> void:
	match state:
		DoorState.CLOSED:
			anim_player.play(&"close")
		DoorState.OPEN:
			anim_player.play(&"open")
	anim_player.animation_finished.connect(func(_anim):
		print("Finched")
		finished.emit()
	)
	anim_player.advance(anim_player.current_animation_length) # advance not seek so anim finished signal fires

	if interaction:
		$InteractArea.interaction = interaction

func open() -> void:
	if state == DoorState.OPEN:
		finished.emit.call_deferred()
		return

	state = DoorState.OPEN
	anim_player.play(&"open")

func close() -> void:
	if state == DoorState.CLOSED:
		finished.emit.call_deferred()
		return

	state = DoorState.CLOSED
	anim_player.play(&"close")

func toggle_open() -> void:
	call(&"open" if state == DoorState.CLOSED else &"close")
