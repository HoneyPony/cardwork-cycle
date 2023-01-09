extends Control

func _on_Button_pressed():
	SceneTransitions.change_scene_to(GS.Game)
	
func _ready():
	if Flags.skip_tutorial:
		$L4.text = "Looking around your new farm, you spot a peculiar looking rock. Hidden under it you find a dusty scroll, and a dustier deck of cards."
	
func _process(delta):
	if Input.is_action_just_pressed("mouse"):
		var anim = $AnimationPlayer
		anim.seek(anim.current_animation_length)
