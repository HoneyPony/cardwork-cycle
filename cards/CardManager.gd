extends Node2D

onready var camera = get_node("../Camera")

# Nullable! Be careful
var current_card = null

func _ready():
	GS.hand = self
	
	call_deferred("starting_hand")

func starting_hand():
	GS.add_card_to_hand(GS.card_basic_plant)
	GS.add_card_to_hand(GS.card_basic_plant)
	GS.add_card_to_hand(GS.card_free_1x1_water)
	GS.turn_state = GS.TurnState.PLAYING_CARDS

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
		current_card.release()
		current_card = null
		
func compute_y(theta, o, s):
	if theta < 0.001:
		return 0
	var k = (o / sin(theta)) - s
	var b = sqrt((s + k) * (s + k) - o * o)
	
	return s + k - b
		
func organize_cards(card_is_picked_up):
	var center_card_height = 300.0
	
	var x_step = 200
	var angle_step = deg2rad(4)
	
	var num_cards = get_child_count()
	var start = -(num_cards - 1.0) / 2
	
	var y_base = -260
	if card_is_picked_up:
		y_base = 80
	
	for i in range(0, get_child_count()):
		var c = get_child(i)
		
		var x_offset = x_step * (i + start)
		var angle_offset = angle_step * (i + start)
		
		#var y_offset = abs(x_offset) * tan(abs(angle_offset))
		var y_offset = compute_y(abs(angle_offset), abs(x_offset), 140)
		
		var hand_pos = Vector2(x_offset, y_base + y_offset)

		c.in_hand_position = hand_pos
		c.in_hand_hover_position = Vector2(hand_pos.x, y_base)
		c.in_hand_rotation = angle_offset
	
	
#func update_camera():
#	var x = camera.position.x
#	if current_card:
#		var dist_to_card = abs(current_card.position.x - x)
#		var max_dist = get_viewport().size.x * 0.5 - 180
#
##		if dist_to_card > max_dist:	
##			var cx = current_card.position.x
##			var mx = get_global_mouse_position().x
##			var move_mouse_to_card = (cx - mx)
##
##			camera.position.x += move_mouse_to_card * 0.1
#
##		var dist_to_card = abs(current_card.position.x - x)
##
#		#var t = dist_to_card / 10000
#		#t = clamp(t, 0.0, 0.1)
#		if dist_to_card > max_dist:
#			var target_x = (current_card.position.x + get_global_mouse_position().x) * 0.5
#			var diff = (target_x - x) * 0.03
#			if abs(diff) > 5:
#				diff = sign(diff) * 5
#			x += diff
#			camera.position.x = x

func update_camera():
	# TODO: Implement scroll-wheel-based scrolling, maybe?
	pass
	
func card_is_picked_up():
	if is_instance_valid(current_card):
		return current_card.is_picked_up()
	return false
	
func _physics_process(delta):
	if GS.turn_state == GS.TurnState.UPDATING:
		return
	
	# This node is offset off the bottom of the camera viewport.size.y / 2
	position.y = camera.position.y + get_viewport().size.y / 2
	#position.y = get_viewport().size.y / 2
	
	var card_picked_up = card_is_picked_up()
	if not card_picked_up:
		var under_mouse = find_card_under_mouse()
		
		if under_mouse != current_card:
			release_current_card()
			current_card = under_mouse
			
			if is_instance_valid(current_card):
				current_card.hover()
			
	organize_cards(card_picked_up)
	update_camera()
	
	if get_child_count() == 0 and GS.turn_state == GS.TurnState.PLAYING_CARDS:
		GS.end_turn()
			
	
