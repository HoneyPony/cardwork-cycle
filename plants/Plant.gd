extends Node2D

var health = 3
var water = 0
var defense = 0

func _ready():
	pass

func update_display():
	$HeartMarker/HealthNum.text = String(health)
	$WaterMarker/WaterNum.text = String(water)
	$DefenseMarker/DefenseNum.text = String(defense)
	
	$HeartMarker.visible = (health > 0)
	$WaterMarker.visible = (water > 0)
	$DefenseMarker.visible = (defense > 0)

func _process(delta):
	update_display()
