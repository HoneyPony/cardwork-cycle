extends Area2D

var hovering = false

# The rotation of the card while it is not hovered. Updated by the CardManager
var in_hand_rotation = 0

func update_scale():
	var target_scale = 1.0
	var target_rot = in_hand_rotation
	if hovering:
		target_scale = 1.3
		target_rot = 0
		
	scale.x += (target_scale - scale.x) * 0.2
	scale.y = scale.x
	
	rotation += (target_rot - rotation) * 0.1

func _physics_process(delta):
	
		
	update_scale()
