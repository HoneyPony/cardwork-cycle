extends Control

func _on_PlayButton_pressed():
	GS.reset_all_state()
	get_tree().change_scene_to(GS.Intro)
