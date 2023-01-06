extends Node2D

# Nullable! Be careful
var current_card = null

func find_card_under_mouse():
	var space = get_world_2d().direct_space_state
	var mouse = get_global_mouse_position()

	var collisions = space.intersect_point(mouse, 32, [], 0x7FFFFFFF, false, true)
	
	var card = null
	
	for collision in collisions:
		var obj = collision["collider"]
		if obj.is_in_group("Card"):
			card = obj
			
			# Always prefer the current card to any other card, to prevent
			# oscillating behavior.
			if card == current_card:
				return card
			
	return card
	
func release_current_card():
	if is_instance_valid(current_card):
		current_card.hovering = false
		current_card = null
		
func organize_cards():
	var center_card_height = 300.0
	var edge_card_height = 180.0
	var radius = center_card_height * 4.0
	
	var r1 = radius - center_card_height
	var r2 = radius - edge_card_height
	
	var center = Vector2(0, r1)
	
	var num_cards = get_child_count()
	
	var angle = acos(r1 / r2)
	var angle_step = (angle * 2) / (num_cards - 1)
	
	var cur_angle = angle + PI * 0.5
	
	for c in get_children():
		var p = polar2cartesian(radius, cur_angle)
		p.y *= -1
		
		c.position = center + p
		c.in_hand_rotation = PI - (cur_angle + 0.5 * PI)
		
		cur_angle -= angle_step
	
	
func _physics_process(delta):
	# This node is parented to the camera, so we can offset to the
	# bottom of the camera simply by going viewport.size.y / 2
	
	position.y = get_viewport().size.y / 2
	
	var under_mouse = find_card_under_mouse()
	
	if under_mouse != current_card:
		release_current_card()
		current_card = under_mouse
		
		if is_instance_valid(current_card):
			current_card.hovering = true
			
	organize_cards()
			
	
