extends Sprite

export var dynamic_display = false

var associated_card = null

var last_checked = 0

func update_display():
	var q = associated_card.quantity + last_checked
	
	var dq = String(q)
	if last_checked != 0:
		dq = "[color=#3d3]" + dq + "[/color]"
	
	$Desc.bbcode_text = "[center]" + associated_card.desc.replace("$DQ", dq) + "[/center]"

func set_color(color: Color):
	$Title.add_color_override("font_color", color)
	$Desc.add_color_override("default_color", color)
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
		
	if associated_card.icon != null:
		$Icon.texture = associated_card.icon
	
	update_display()

func _process(delta):
	if not dynamic_display:
		return

	if dynamic_display:
		if GS.cursor.current_damage_add != last_checked:
			last_checked = GS.cursor.current_damage_add
			
			update_display()
