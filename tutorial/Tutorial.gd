extends Label

var lines = [
"Dear <name>,\n\nI hope this dusty scroll finds you well. I am the previous farmer who tended this land, and I have high hopes that you will make even better use of it than myself."
,"But, I hypothesize that you are quite untrained in the art of farming. I intend to teach you the basic knowledge you will need to make use of this farm."
,"Let us begin.\n\nFirst, to navigate the farm, click your left mouse button somewhere on the ground and drag the mouse."
,"Next, to do anything at all on this farm you must play a card. Cards accomplish many different tasks... planting plants, watering those plants, and fighting off pests. Each card costs ENERGY to play, indicated by the orb in your bottom-left, and indicated on each card in its top-right corner."
,"Your cards are organized at the bottom of the screen. To move them left and right, such as to see cards that you cannot currently see, use the scroll wheel on your mouse."
,"You should plant a Basic Seeds somewhere on the tilled soil. Left click the Basic Seeds card in your inventory, and then drag it above on to your farm in order to play it.\n\nThis card will indicate where it can be played with a green spinning circle."
,"With your seeds planted, you can see one important detail: each plant you plant has some amount of health. You will want to keep your plants alive until they are fully grown!"
,"Now, you will want to water your seeds. Use the Water Drop card to water your plant."
,"Notice that your plants each have a water indicator. The water indicator is decreased at the end of each of your turns. If it is 0 after it is decreased, the plant will take damage at that time."
,"The final statistic each plant has is its Immunity, which you can apply with the SOMETHING card, as well as others."
,"Each point of Immunity a plant has protects it from exactly one point of damage. However, unlike health, Immunity automatically wears off over time.\n\nEach of these plant statistics caps out at 10."
,"Now that you have played as many cards as you possibly can, push the End Turn button to end your turn. Then, you will see the effects of your water... and any enemies, if they exist, will attack at this time."
,"The final primary purpose of your cards is to fight off pests that would attack your farm. Use your Whack! card to deal some damage to that bug."
,"You are now equipped with all the basic knowledge that a farmer should have. One last detail, however: what is it your plants are for, anyways?"
,"Well, each time you water your plants, they grow one more stage. And, once you water them enough times, you will automatically harvest them... and here you will get to choose a new card to add to your deck. The more difficult plants to grow will give you more valuable cards."
,"You may also choose to harvest your plants for money, which can be spent in the local shop on different kinds of upgrades."
,"Finally, there is one rare plant that we have been striving to grow for centuries, and have as of yet failed entirely. You will find its seeds by growing valuable cards, and then you can tackle the challenge of growing that elusive plant."
,"Now go, and farm!"]
var current_line = 0

func end_tutorial():
	GS.tutorial = false
	queue_free()

func _ready():
	update_tutorial()
	GS.turn_state = GS.TurnState.WAITING_FOR_TUTORIAL

func update_tutorial():
	text = lines[current_line]
	
	if current_line == 4:
		GS.add_card_to_hand(GS.card_basic_plant)
		GS.add_card_to_hand(GS.card_basic_plant)
		GS.add_card_to_hand(GS.card_basic_plant)
		GS.turn_state = GS.TurnState.PLAYING_CARDS
	
func step_tutorial():
	current_line += 1
	update_tutorial()

func _on_NextButton_pressed():
	step_tutorial()
