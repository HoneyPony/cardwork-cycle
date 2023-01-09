extends TextureRect

export var description = ""
export var cost = 5

var bought = false

export var is_energy = true

export var up_num = 1

func _ready():
	$Button.text = "Buy (" + String(cost) + " gold)"
	
	$Button.connect("pressed", self, "_on_buy")
	
func _on_buy():
	if bought:
		return
	
	if GS.gold >= cost:
		bought = true
		GS.gold -= cost
		
		if is_energy:
			GS.energy_max += 1
			GS.energy += 1
		else:
			if up_num == 1:
				GS.tilemap.up1()
			elif up_num == 2:
				GS.tilemap.up2()
			elif up_num == 3:
				GS.card_draw_count += 1
			elif up_num == 4:
				GS.auto_water = true
			



func _process(delta):
	if bought:
		$Button.hide()
	else:
		$Button.show()
		$Button.disabled = (GS.gold < cost)

