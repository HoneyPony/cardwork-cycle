extends Node

# Cards from the same "build" make other cards in that "build" more
# common.
var water_multiplier = 1
var defense_multiplier = 1
var attack_multiplier = 1

func has_duplicate_card(result: Array, card):
	for c in result:
		if c == card:
			return true
	return false
	
func add_copies(set: Array, count: int, card):
	for i in range(0, count):
		set.push_back(card)
		
func add_waters(set: Array, count: int, card):
	for i in range(0, int(count * water_multiplier)):
		set.push_back(card)
		
func add_defs(set: Array, count: int, card):
	for i in range(0, int(count * defense_multiplier)):
		set.push_back(card)

func pick_cards(set: Array):
	var result = []
	
	# Allow duplicates if they are chosen repeatedly.
	var dup_health = 30
	
	while result.size() < 3:
		var index = int(rand_range(0, set.size()))
		if index >= set.size():
			continue
			
		var candidate = set[index]
		if dup_health >= 0:
			if has_duplicate_card(result, candidate):
				dup_health -= 1
				continue
			
		result.push_back(candidate)

	return result

func pick_plant1_cards(health):
	var set = []
	
	add_waters(set, 4, GS.card_water2_1x1)
	add_waters(set, 4, GS.card_water1_2x2)
	add_waters(set, 4, GS.card_drain1_dmg3)
	
	add_defs(set, 4, GS.card_def2_dmg1)
	add_defs(set, 4, GS.card_heal1_dmg1)
	add_defs(set, 4, GS.card_3def_1)
	
	add_copies(set, 4, GS.card_basic_plant)
	add_copies(set, 4, GS.card_medium_plant)
	
	add_copies(set, 2, GS.card_free_1x1_water)
	
	return pick_cards(set)
