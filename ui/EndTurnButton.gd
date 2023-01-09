extends ButtonSFX

func _ready():
	connect("pressed", self, "_on_pressed")
	
func _on_pressed():
	GS.end_turn()
	
func contains_mouse(control: Control):
	var r = Rect2(Vector2.ZERO, control.rect_size)
	return r.has_point(control.get_local_mouse_position())

func _process(delta):
	if GS.tutorial:
		if TutorialSteps.should_display_end_turn():
			visible = true
		else:
			visible = false
	else:
		visible = true

	GS.end_turn_mouse = (visible and contains_mouse(self))
	
