extends Sprite

export var dynamic_display = false

var associated_card = null

var last_checked = 0

func update_display():
	var q = associated_card.quantity + last_checked
	
	$Desc.text = associated_card.desc.replace("$DQ", String(q))

func _ready():
	update_display()

func _process(delta):
	if not dynamic_display:
		return

	if dynamic_display:
		if GS.cursor.current_damage_add != last_checked:
			last_checked = GS.cursor.current_damage_add
			
			update_display()
