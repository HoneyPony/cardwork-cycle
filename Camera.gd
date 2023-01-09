extends Camera2D

var last_stored_pos = Vector2.ZERO

var back_to_pos_timer = 0

func _ready():
	GS.camera = self
	
func _physics_process(delta):
	if is_instance_valid(GS.current_obj):
		var p = GS.current_obj.global_position
		global_position += (p - global_position) * 0.13
		
		back_to_pos_timer = 0.3
	elif back_to_pos_timer > 0:
		global_position += (last_stored_pos - global_position) * 0.13
		back_to_pos_timer -= delta
	else:
		last_stored_pos = position
