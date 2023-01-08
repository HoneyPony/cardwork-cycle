extends Button

func _ready():
	connect("pressed", self, "_on_pressed")
	
func _on_pressed():
	GS.end_turn()

func _physics_process(delta):
	if GS.tutorial:
		if TutorialSteps.should_display_end_turn():
			visible = true
		else:
			visible = false
	else:
		visible = true
