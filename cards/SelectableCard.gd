extends Control

var is_selected = false
var is_hovered = false

var associated_card

# The rotation of the card while it is not hovered. Updated by the CardManager
var in_hand_rotation = 0

var in_hand_position = Vector2.ZERO
var in_hand_hover_position = Vector2.ZERO

var card_child

func _ready():
	card_child = $CardBase

#func _ready():
#	in_hand_position = 
#	in_hand_hover_position = position

func update_transform():
	var target_scale = 1.0
	var target_rot = in_hand_rotation
	var target_pos = in_hand_position
	#z_index = 0
	if is_hovered:
		target_scale = 1.1
		target_rot = 0
		target_pos = in_hand_hover_position
		#z_index = 100
		
	if is_selected:
		target_pos.y -= 32
		
	target_scale *= 0.5 # Account fo rscaling
	target_pos += Vector2(rect_size.x * 0.5, rect_size.y * 0.5)
		
	card_child.scale.x += (target_scale - card_child.scale.x) * 0.2
	card_child.scale.y = card_child.scale.x
	
	#rotation += (target_rot - rotation) * 0.1
	card_child.position += (target_pos - card_child.position) * 0.15
	
func check_hover():
	var m = get_local_mouse_position()
	return m.x >= 0 && m.y >= 0 && m.x <= rect_size.x && m.y <= rect_size.y
	
func _physics_process(delta):
	is_hovered = check_hover()
	
	if is_hovered:
		if Input.is_action_just_released("mouse"):
			is_selected = !is_selected
			if is_selected:
				get_parent().get_parent().deselect_others(self)
			else:
				get_parent().get_parent().deselect_all()
			
	update_transform()
