extends Camera2D

func _ready():
	GS.camera = self
	
func _physics_process(delta):
	if is_instance_valid(GS.current_obj):
		var p = GS.current_obj.global_position
		global_position += (p - global_position) * 0.2
