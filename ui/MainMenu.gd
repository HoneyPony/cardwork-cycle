extends Control

func _on_PlayButton_pressed():
	GS.reset_all_state()
	SceneTransitions.change_scene_to(GS.Intro)
