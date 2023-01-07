extends Area2D

const STATE_IN_HAND = 0
const STATE_HOVER = 1
const STATE_PICKUP = 2

var state = STATE_IN_HAND

var associated_card

# The rotation of the card while it is not hovered. Updated by the CardManager
var in_hand_rotation = 0

var in_hand_position = Vector2.ZERO
var in_hand_hover_position = Vector2.ZERO

func is_picked_up():
	return state == STATE_PICKUP

func release():
	# TODO: Figure out how this will work with picked up cards
	if state == STATE_HOVER:
		state = STATE_IN_HAND
		
func hover():
	if state == STATE_IN_HAND:
		state = STATE_HOVER

func update_transform():
	var target_scale = 1.0
	var target_rot = in_hand_rotation
	var target_pos = in_hand_position
	z_index = 0
	if state == STATE_HOVER or state == STATE_PICKUP:
		target_scale = 1.3
		target_rot = 0
		target_pos = in_hand_hover_position
		z_index = 100
	if state == STATE_PICKUP:
		# Position should be locked
		target_pos = position
		target_scale = 0.7
		
	scale.x += (target_scale - scale.x) * 0.2
	scale.y = scale.x
	
	rotation += (target_rot - rotation) * 0.1
	position += (target_pos - position) * 0.15
	
func play_self():
	if associated_card.action == GS.Action.PLANT:
		GS.cursor.new_plant(associated_card)
	
	queue_free()
	
func try_play_self():
	GS.release_current_card(self)
	
	if associated_card.action == GS.Action.PLANT:
		if GS.cursor.may_play_card():
			play_self()
			return
	
	# If we can't play the card, simply return to hover state.
	state = STATE_HOVER
	
func _physics_process(delta):
	if state == STATE_PICKUP:
		global_position = get_global_mouse_position()
		position.y += 98 + 30
		
		if Input.is_action_just_released("mouse"):
			try_play_self()
	
	if state == STATE_HOVER:
		if Input.is_action_just_pressed("mouse"):
			state = STATE_PICKUP
			GS.set_current_card(self)
			
	update_transform()
