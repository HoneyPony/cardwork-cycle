extends Sprite

export var dynamic_display = false

var associated_card = null

var last_checked = 0

func update_display():
	var q = associated_card.quantity + last_checked
	
	$Desc.text = associated_card.desc.replace("$DQ", String(q))

func set_color(color: Color):
	$Title.add_color_override("font_color", color)
	$Desc.add_color_override("font_color", color)
	$Cost.add_color_override("font_color", color)

func _ready():
	var cat = associated_card.cat
	
	if cat == GS.CAT_ATK:
		texture = GS.CardTexAtk
	elif cat == GS.CAT_DEF:
		texture = GS.CardTexDef
		set_color(Color.lightgray)
	elif cat == GS.CAT_WATER:
		texture = GS.CardTexWater
	elif cat == GS.CAT_SEED:
		texture = GS.CardTexSeed
	
	update_display()

func _process(delta):
	if not dynamic_display:
		return

	if dynamic_display:
		if GS.cursor.current_damage_add != last_checked:
			last_checked = GS.cursor.current_damage_add
			
			update_display()
