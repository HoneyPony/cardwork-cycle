extends CanvasLayer

var next = null

func change_scene_to(scene: PackedScene):
	next = scene
	$AnimationPlayer.play("FadeOutIn")

func faded():
	if next == null:
		return
	get_tree().change_scene_to(next)
