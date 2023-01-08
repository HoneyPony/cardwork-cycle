extends Panel

func contains_mouse(control: Control):
	var r = Rect2(Vector2.ZERO, control.rect_size)
	return r.has_point(control.get_local_mouse_position())

func _process(delta):
	GS.upper_panel_mouse = contains_mouse(self)
