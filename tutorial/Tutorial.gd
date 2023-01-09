extends Label

var lines = [
"Dear <name>,\n\nI hope this dusty scroll finds you well. I am the previous farmer who tended this land, and I have high hopes that you will make even better use of it than myself."
,"But, I hypothesize that you are quite untrained in the art of farming. I intend to teach you the basic knowledge you will need to make use of this farm."
,"Let us begin.\n\nFirst, to navigate the farm, click your left mouse button somewhere on the ground and drag the mouse."
,"Next, to do anything at all on this farm you must play a card. Cards accomplish many different tasks... planting plants, watering those plants, and fighting off pests. Each card costs ENERGY to play, indicated by the orb in the bottom-left, and indicated on each card in its top-right corner."
,"Your cards are organized at the bottom of the screen. To move them left and right, such as to see cards that you cannot currently see, use the scroll wheel on your mouse."
,"You should plant a Basic Seeds somewhere on the tilled soil. Left click the Basic Seeds card in your inventory, and then drag it above on to your farm in order to play it.\n\nThis card will indicate where it can be played with a green spinning circle."
,"With your seeds planted, you can see one important detail: each plant you plant has some amount of health. You will want to keep your plants alive until they are fully grown!"
,"Now, you will want to water your seeds. Use the Water Drop card to water your plant."
,"Notice that your plants each have a water indicator. The water indicator is decreased at the end of each of your turns. If, however, the plant had no water, it will take damage."
,"The final statistic each plant has is its immunity, which you can apply with the Netting Shield card, as well as others."
,"Each point of immunity a plant has protects it from exactly one point of damage. However, plants lose 1 immunity at the beginning of your turn.\n\nEach of these plant statistics caps out at 10."
,"Now that you have played as many cards as you possibly can, push the End Turn button to end your turn. Then, you will see the effects of your water... and any enemies, if they exist, will attack at this time."
,"It is now a new turn, and you have drawn new cards."
,"The final primary purpose of your cards is to fight off pests that would attack your farm. Use your Whack! card to deal some damage to that bug."
,"You are now equipped with all the basic knowledge that a farmer should have. One last detail, however: what is it your plants are for, anyways?"
,"Well, each time you water your plants, they grow one more stage. And, once you water them enough times, you will automatically harvest them... and here you will get to choose a new card to add to your deck. Of course, the more valuable cards require more effort to grow."
,"Healthier plants also tend to produce better cards."
,"You may also choose to harvest your plants for money, which can be spent in the local shop on different kinds of upgrades."
,"Finally, there is one rare plant that we have been striving to grow for centuries, and have as of yet failed entirely. You will find its seeds by growing valuable cards, and then you can tackle the challenge of growing that elusive plant."
,"Now go, and farm!"]

var current_line = 0
var turns_with_reqs = [5, 7, 9, 11, 13]

func contains_mouse(control: Control):
	var r = Rect2(Vector2.ZERO, control.rect_size)
	return r.has_point(control.get_local_mouse_position())

func end_tutorial():
	GS.tutorial = false
	GS.tutorial_mouse = false
	GS.card_draw_count = 5 # Back to normal card count
	queue_free()

func _ready():
	TutorialSteps.tutorial = self
	
	update_tutorial()
	GS.turn_state = GS.TurnState.WAITING_FOR_TUTORIAL
	GS.card_draw_count = 2 # Only draw the Whack! card plus some filler

	# DEBUGGING
	# call_deferred("tutorial_debug")

func tutorial_debug():
	tutorial_cards()
	end_tutorial()
	GS.turn_state = GS.TurnState.PLAYING_CARDS
	
	
#
#	GS.add_card_to_hand(GS.card_small_attack)
	GS.add_card_to_hand(GS.card_free_1x1_water)
#	GS.add_card_to_hand(GS.card_win_plant)
	GS.add_card_to_hand(GS.card_basic_plant)
#	GS.add_card_to_hand(GS.card_basic_plant)
#	GS.add_card_to_hand(GS.card_basic_plant)
#	GS.add_card_to_hand(GS.card_add1_expensive)
#	GS.add_card_to_hand(GS.card_def2_all)
#	GS.add_card_to_hand(GS.card_heal_attack_all)
	GS.add_card_to_hand(GS.card_sacrif2_2enem)
#	GS.add_card_to_hand(GS.card_free_atk)
#	GS.add_card_to_hand(GS.card_sacrifice)
#	GS.gold += 200
	GS.energy += 200
	
	for enem in get_tree().get_nodes_in_group("Enemy"):
		enem.spawn_now()


func tutorial_cards():
	GS.add_card_to_hand(GS.card_basic_plant)
	#GS.add_card_to_hand(GS.card_basic_plant)
	GS.add_card_to_hand(GS.card_free_1x1_water)
	GS.add_card_to_hand(GS.card_small_defend)
	
	GS.draw_pile.push_back(GS.card_small_attack)
	#GS.draw_pile.push_back(GS.card_medium_plant)
	
	GS.draw_pile.push_back(GS.card_medium_plant)
	
	GS.discard_pile.push_back(GS.card_buy_1x1_water)
	#GS.discard_pile.push_back(GS.card_buy_1x1_water)
	#GS.discard_pile.push_back(GS.card_buy_1x1_water)
	
	GS.discard_pile.push_back(GS.card_high_plant)
	#GS.discard_pile.push_back(GS.card_high_plant)
	
	
	GS.discard_pile.push_back(GS.card_small_attack)
	#GS.discard_pile.push_back(GS.card_small_attack)
	#GS.discard_pile.push_back(GS.card_small_defend)

func update_tutorial():
	if current_line >= lines.size():
		end_tutorial()
		return
	
	text = lines[current_line]
	
	TutorialSteps.need_end_turn_button = (current_line == 11)
	
	$NextButton.visible = not (current_line in turns_with_reqs)
	
	if current_line == 4:
		tutorial_cards()
		GS.turn_state = GS.TurnState.PLAYING_CARDS
		
	if current_line == 13:
		var plants = get_tree().get_nodes_in_group("Plant")
		var lcoord = Vector2.ZERO
		
		if not plants.empty():
			var plant = plants[0]
			lcoord = plant.position + Vector2(128 * 2, 0)
		
		GS.spawn_bug_lcoord(lcoord).spawn_now()
	
func step_tutorial():
	current_line += 1
	update_tutorial()
	
func _process(delta):
	if not GS.tutorial:
		GS.tutorial_mouse = false
		return
		
	GS.tutorial_mouse = contains_mouse(self) or contains_mouse($NextButton)
	
	if TutorialSteps.marked_step >= current_line:
		$NextButton.visible = true

func _on_NextButton_pressed():
	step_tutorial()
