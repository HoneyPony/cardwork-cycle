extends Label

func _process(delta):
	text = "(You have " + String(GS.gold) + " gold)"
