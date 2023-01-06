extends CanvasLayer

func _ready():
	visible = get_tree().paused

func pause():
	get_tree().paused = true
	show()
	
func unpause():
	get_tree().paused = false
	hide()
	
func toggle_pause():
	if get_tree().paused:
		unpause()
	else:
		pause()

func _on_ResumeButton_pressed():
	unpause()
	
func _on_QuitButton_pressed():
	unpause()
	get_tree().change_scene_to(GS.MainMenu)
	
func _process(delta):
	if Input.is_action_just_pressed("pause_button"):
		toggle_pause()
