extends Control

var current_card = null

onready var win_menu = $WinMenu

var tips = [
"Tip: Don't discount basic plants! They have tons of health, so they can absorb damage, and they  only take a few turns to grow."
,"Tip: Immunity protects your plants from taking damage in all situations! Including when they have no water."
,"Tip: Enemies attack the plants that are closest to them. Plan accordingly!"
,"Tip: Different seed tiers give you different cards. Although the rare cards are powerful, sometimes they need some help from lower-tier cards."
]

var tip_num = 0

func _ready():
	$ConfirmButton.disabled = true
	get_parent().hide()
	
	win_menu.hide()
	
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
	win_menu.visible = false
	setup_card($Cards/Card, cards[0])
	setup_card($Cards/Card2, cards[1])
	setup_card($Cards/Card3, cards[2])
	
	$TipPanel/Tip.text = tips[tip_num]
	tip_num = (tip_num + 1) % tips.size()
	$TipPanel.show()
	
	SFX.plant_jingle.play_usual()
	
func setup_win():
	win_menu.visible = true
	$TipPanel.hide()
	
		
	SFX.win_jingle.play_usual()

func contains_mouse(control: Control):
	var r = Rect2(Vector2.ZERO, control.rect_size)
	return r.has_point(control.get_local_mouse_position())
	
func _process(delta):
	GS.new_cards_mouse = contains_mouse(self)

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
			if card.associated_card == GS.card_win_plant:
				CardCreation.has_win_card = true
				
			CardCreation.picked_cat(card.associated_card.cat)
			
	remove_card_children()
			
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
	
	
	
