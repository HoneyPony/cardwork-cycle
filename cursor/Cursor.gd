extends Sprite

func _physics_process(delta):
	var p = get_global_mouse_position()
	p = (p / 64).floor() * 64
	
	global_position = p + Vector2(32, 32)
