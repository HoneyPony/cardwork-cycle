extends Button
class_name ButtonSFX

func _ready():
	connect("mouse_entered", self, "_sfx_mouse_enter")
	connect("mouse_exited", self, "_sfx_mouse_exit")
	connect("pressed", self, "_sfx_mouse_pressed")
	
func _sfx_mouse_enter():
	SFX.button_hover.play_sfx()
	
func _sfx_mouse_exit():
	SFX.button_hover.play_sfx()
	
func _sfx_mouse_pressed():
	SFX.button_click.play_sfx()
