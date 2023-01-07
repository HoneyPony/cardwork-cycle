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
	
	node.position.y = y

func update_display():
	$H/HeartMarker/HealthNum.text = String(health)
	$W/WaterMarker/WaterNum.text = String(water)
	$D/DefenseMarker/DefenseNum.text = String(defense)
	
	# Don't update visibility while the animation is going...?
	if not $AnimationPlayer.is_playing():
		$H/HeartMarker.visible = (health > -1) # I guess
		$W/WaterMarker.visible = (water > 0)
		$D/DefenseMarker.visible = (defense > 0)
	
	# Randomly move markers and plant sprite for a little bit more life.
	# One option for this: JitterFX.gd, inspired by the main menu of my game
	# HaleyHeartbeat
	#$HeartMarker.position = centered_lpf_noise($HeartMarker.position)
	#$WaterMarker.position = centered_lpf_noise($WaterMarker.position)
	#$DefenseMarker.position = centered_lpf_noise($DefenseMarker.position)
	
	#$Plant.position = centered_lpf_noise($Plant.position)
	
	# Another option: sine wave, may look nicer than noise for this purpose.
	sine_y_offset($H, 28)
	sine_y_offset($W, 64)
	sine_y_offset($D, 100)
	

func _process(delta):
	update_display()
	
func take_turn():
	var anim = $AnimationPlayer
	
	if water >= 1:
		anim.queue("WaterPlant")
	else:
		anim.queue("NoWater")
	
func dec_health():
	health -= 1
	
func water_plant():
	water -= 1
	
func upgrade_plant():
	$Plant.frame += 1
	
func turn_over():
	return not $AnimationPlayer.is_playing()
