extends Node2D

export var health = 3
var water = 0
var defense = 0

export var anim_frames: SpriteFrames

# If the plant is "consumed", that means the card / gold popup has been
# shown, and the plant should be queue_freed()
var consumed = false

func _ready():
	$Plant.frames = anim_frames

func centered_lpf_noise(in_pos):
	var r = rand_range(0, 32)
	var th = rand_range(0, 6.28)
	var pos = Vector2(64, 64) + polar2cartesian(r, th)
	
	return in_pos + (pos - in_pos) * 0.005
	
func sine_y_offset(node, offset):
	var theta = GS.global_sine_timer * 64 + offset
	var y = sin(theta * (PI / 32.0))
	
	node.position.y = y
	
# Can be called from animations to explicitly update the visibility at some point.
func update_markers_visibility():
	$H/HeartMarker.visible = (health > -1) # I guess
	$W/WaterMarker.visible = (water > 0)
	$D/DefenseMarker.visible = (defense > 0)

func update_display():
	$H/HeartMarker/HealthNum.text = String(health)
	$W/WaterMarker/WaterNum.text = String(water)
	$D/DefenseMarker/DefenseNum.text = String(defense)
	
	# Don't update visibility while the animation is going...?
	if not $AnimationPlayer.is_playing():
		update_markers_visibility()
	
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
	
	anim.queue("Delay")
	
	if water >= 1:
		#print($Plant.frame)
		#print($Plant.frames.frames.size() - 1)
		if $Plant.frame == $Plant.frames.get_frame_count("default") - 1:
			anim.queue("PlantIsDone")
			consumed = true
		else:
			anim.queue("WaterPlant")
	else:
		anim.queue("NoWater")
	
func dec_health():
	# TODO: Animate shield rather than heart...
	if defense > 0:
		defense -= 1
		return
	
	health -= 1
	if health <= 0:
		$AnimationPlayer.queue("OutOfHealth")
	
func start_health_anim():
	if defense > 0:
		$ShieldFX.play("Pop")
	else:
		$HeartFX.play("Pop")
	
func water_plant():
	water -= 1
	
func popup_menu():
	GS.popup_card_selection(CardCreation.pick_plant1_cards(health))
	
func upgrade_plant():
	$Plant.frame += 1
	
func apply_defense(amount):
	defense += amount
	
func turn_over():
	# If we are being polled about our turn, then the card selection
	# dialog must be related to this plant.
	if GS.waiting_for_card_selection:
		return false
	return not $AnimationPlayer.is_playing()
	
func finalize_turn():
	if consumed:
		queue_free()
