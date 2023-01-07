extends Control

var current_card = null

func _ready():
	$ConfirmButton.disabled = true
	get_parent().hide()
	
	GS.card_selector_ui = self


#func find_card_under_mouse():
#	var space = get_world_2d().direct_space_state
#	var mouse = get_parent().get_local_mouse_position()
#
#	var collisions = space.intersect_point(mouse, 32, [], 0x7FFFFFFF, false, true)
#
#	var card = null
#
#	for collision in collisions:
#		var obj = collision["collider"]
#		if obj.is_in_group("SelectableCard"):
#			card = obj
#
#			# Always prefer the current card to any other card, to prevent
#			# oscillating behavior.
#			if card == current_card:
#				return card
#
#	return card

func popup():
	get_parent().show()
	$AnimationPlayer.play("Popup")
	
func release_current_card():
	if current_card == null:
		return
		
	current_card.is_hovered = false
	current_card = null
	
func setup_card(node: SelectableCard, card):
	var b = GS.get_card_base(card)
	node.add_child(b)
	b.position.x = 400 / 4.0
	b.position.y = 560 / 4.0
	node.card_child = b
	node.associated_card = card
	
func setup_cards(cards: Array):
	setup_card($Cards/Card, cards[0])
	setup_card($Cards/Card2, cards[1])
	setup_card($Cards/Card3, cards[2])

#func _physics_process(delta):
#	var under_mouse = find_card_under_mouse()
#
#	if under_mouse != current_card:
#		release_current_card()
#		current_card = under_mouse
#
#		if is_instance_valid(current_card):
#			current_card.is_hovered = true

func deselect_others(selected_card):
	$GoldButton.pressed = false
	for card in $Cards.get_children():
		if card != selected_card:
			card.is_selected = false
			
	$ConfirmButton.disabled = false
	
func deselect_all():
	$GoldButton.pressed = false
	for card in $Cards.get_children():
		card.is_selected = false
		
	# Nothing is selected -> confirm button is greyed out.
	$ConfirmButton.disabled = true

func _on_GoldButton_pressed():
	for card in $Cards.get_children():
		card.is_selected = false
		
	# If the gold button is also not pressed, we can't confirm.
	$ConfirmButton.disabled = not $GoldButton.pressed

func _on_ConfirmButton_pressed():
	
	for card in $Cards.get_children():
		if card.is_selected:
			card.is_selected = false
			# Add new cards to discard pile
			GS.discard_pile.push_back(card.associated_card)
			
	if $GoldButton.pressed:
		$GoldButton.pressed = false
		GS.gold += 1
	
	GS.waiting_for_card_selection = false
	
	$AnimationPlayer.play("Popdown")
	
func remove_card_children():
	$Cards/Card.destroy_card_child()
	$Cards/Card2.destroy_card_child()
	$Cards/Card3.destroy_card_child()
	
	get_parent().hide()
	
	
	
