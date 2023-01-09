extends Control

func _on_Button_pressed():
	get_tree().change_scene_to(GS.Game)
	
func _process(delta):
	if Input.is_action_just_pressed("mouse"):
		var anim = $AnimationPlayer
		anim.seek(anim.current_animation_length)
