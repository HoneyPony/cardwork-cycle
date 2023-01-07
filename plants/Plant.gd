extends Node2D

var health = 3
var water = 0
var defense = 0

func _ready():
	pass

func centered_lpf_noise(in_pos):
	var r = rand_range(0, 32)
	var th = rand_range(0, 6.28)
	var pos = Vector2(64, 64) + polar2cartesian(r, th)
	
	return in_pos + (pos - in_pos) * 0.005
	
func sine_y_offset(node, offset):
	var theta = GS.global_sine_timer * 64 + offset
	var y = sin(theta * (PI / 32.0))
	
	node.position.y = 64 + y

func update_display():
	$HeartMarker/HealthNum.text = String(health)
	$WaterMarker/WaterNum.text = String(water)
	$DefenseMarker/DefenseNum.text = String(defense)
	
	$HeartMarker.visible = (health > 0)
	$WaterMarker.visible = (water > 0)
	$DefenseMarker.visible = (defense > 0)
	
	# Randomly move markers and plant sprite for a little bit more life.
	# One option for this: JitterFX.gd, inspired by the main menu of my game
	# HaleyHeartbeat
	#$HeartMarker.position = centered_lpf_noise($HeartMarker.position)
	#$WaterMarker.position = centered_lpf_noise($WaterMarker.position)
	#$DefenseMarker.position = centered_lpf_noise($DefenseMarker.position)
	
	#$Plant.position = centered_lpf_noise($Plant.position)
	
	# Another option: sine wave, may look nicer than noise for this purpose.
	sine_y_offset($HeartMarker, 28)
	sine_y_offset($WaterMarker, 64)
	sine_y_offset($DefenseMarker, 100)
	

func _process(delta):
	update_display()
