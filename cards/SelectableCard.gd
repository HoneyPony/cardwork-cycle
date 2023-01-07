extends Area2D

var is_selected = false
var is_hovered = false

var associated_card

# The rotation of the card while it is not hovered. Updated by the CardManager
var in_hand_rotation = 0

var in_hand_position = Vector2.ZERO
var in_hand_hover_position = Vector2.ZERO

func _ready():
	in_hand_position = position
	in_hand_hover_position = position

func update_transform():
	var target_scale = 1.0
	var target_rot = in_hand_rotation
	var target_pos = in_hand_position
	z_index = 0
	if is_hovered:
		target_scale = 1.1
		target_rot = 0
		target_pos = in_hand_hover_position
		z_index = 100
		
	if is_selected:
		target_pos.y -= 32
		
	scale.x += (target_scale - scale.x) * 0.2
	scale.y = scale.x
	
	rotation += (target_rot - rotation) * 0.1
	position += (target_pos - position) * 0.15
	
func _physics_process(delta):
	print(get_world_2d())
	
	if is_hovered:
		if Input.is_action_just_released("mouse"):
			is_selected = !is_selected
			if is_selected:
				get_parent().get_parent().deselect_others(self)
			else:
				get_parent().get_parent().deselect_all()
			
	update_transform()
