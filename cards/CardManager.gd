extends Node2D

#onready var camera = get_node("../Camera")

onready var dummy = get_node("../CardDummy")

# Nullable! Be careful
var current_card = null

var card_scroll_offset = 0

func _ready():
	GS.hand = self
	
#	call_deferred("starting_hand")

#func starting_hand():
	#GS.add_card_to_hand(GS.card_basic_plant)
	#GS.turn_state = GS.TurnState.PLAYING_CARDS

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

	if num_cards > 0:
		# Only change scroll offset when we have a legitimate value
		card_scroll_offset = clamp(card_scroll_offset, start, -start)
		start += card_scroll_offset
	
	var y_base = -200#-260
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
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				card_scroll_offset -= 0.5
			if event.button_index == BUTTON_WHEEL_DOWN:
				card_scroll_offset += 0.5
	
func card_is_picked_up():
	if is_instance_valid(current_card):
		return current_card.is_picked_up()
	return false
	
func clear_hand():
	for card in get_children():
		card.discard()
		
	card_scroll_offset = 0
	
var drag_camera = false
var drag_center = Vector2.ZERO

func _physics_process(delta):
	if GS.turn_state == GS.TurnState.UPDATING:
		organize_cards(true) # Hide cards at bottom
		return
	
	# This node is offset off the bottom of the camera viewport.size.y / 2
	position.y = get_viewport().size.y / 2
	dummy.position.y = position.y
	#position.y = get_viewport().size.y / 2
	
	var ignoring_interactions = GS.shop_open or GS.upper_panel_mouse or GS.tutorial_mouse or GS.new_cards_mouse or GS.end_turn_mouse
	
	var card_picked_up = card_is_picked_up()
	
	if ignoring_interactions:
		release_current_card()
	else:	
		
		# Don't check cards if one is already picked up or if the camera is dragging
		if not card_picked_up and not drag_camera:
			var under_mouse = find_card_under_mouse()
			
			if under_mouse != current_card:
				SFX.rand_card()
				release_current_card()
				current_card = under_mouse
				
				if is_instance_valid(current_card):
					current_card.hover()
				
			
	organize_cards(card_picked_up or drag_camera)
	update_camera()
	
	if current_card == null:
		
		if (not ignoring_interactions) and Input.is_action_just_pressed("mouse"):
			drag_camera = true
			drag_center = get_local_mouse_position()
			
	if drag_camera:
		if Input.is_action_pressed("mouse"):
			var m = get_local_mouse_position()
			get_parent().position -= (m - drag_center)
			get_parent().bounds()
			
			# The offset affects the position, so we have to NOT recompute
			# ...? This is the original code I had, but it originally was oscillating,
			# but now it's not, so I guess it's fine...?
			drag_center = m
		else:
			drag_camera = false
		
	if not GS.tutorial:
		if get_child_count() == 0 and GS.turn_state == GS.TurnState.PLAYING_CARDS:
			GS.end_turn()
		
			
	
