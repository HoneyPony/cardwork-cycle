extends Node

func has_duplicate_card(result: Array, card):
	for c in result:
		if c == card:
			return true
	return false
	
func add_copies(set: Array, count: int, card):
	for i in range(0, count):
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
	
	add_copies(set, 10, GS.card_free_1x1_water)
	
	return pick_cards(set)
