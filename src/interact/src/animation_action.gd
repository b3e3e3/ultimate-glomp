class_name AnimationAction extends GameAction

@export_node_path("AnimationPlayer") var anim_player_path: NodePath
@export var anim_name: StringName = &"default"

var anim_player: AnimationPlayer


func on_start(character: Character, _owner: Node) -> void:
	if not anim_player:
		anim_player = character.animation_player

	anim_player.play(anim_name)

	if anim_player.is_playing():
		print("Is playing. Waiting...")

		await anim_player.animation_finished

		print("Done")

		anim_player.stop()

		finish(true)
		return
	else:
		print("Wasnt playing")
		finish(false)
