extends Camera2D

var last_stored_pos = Vector2.ZERO

var back_to_pos_timer = 0

onready var TL = get_node("../TileMap/TLBound")
onready var BR = get_node("../TileMap/BRBound")

func _ready():
	GS.camera = self
	
func bounds():
	var v = get_viewport().size * 0.5
	var left = position.x - v.x
	var right = position.x + v.x
	
	var top = position.y - v.y
	var bottom = position.y + v.y
	
	var off_left = (left < TL.position.x)
	var off_right = (right > BR.position.x)
	if off_left and off_right:
		position.x = (TL.position.x + BR.position.x) * 0.5
	elif off_left:
		position.x = TL.position.x + v.x
	elif off_right:
		position.x = BR.position.x - v.x
		
	var off_top = (top < TL.position.y)
	var off_bottom = (bottom > BR.position.y)
	
	if off_top and off_bottom:
		position.y = (TL.position.y + BR.position.y) * 0.5
	elif off_top:
		position.y = TL.position.y + v.y
	elif off_bottom:
		position.y = BR.position.y - v.y
	
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
		
	bounds()
