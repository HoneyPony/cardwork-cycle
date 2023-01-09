extends AudioStreamPlayer

var start_db
var start_pitch

func _ready():
	start_db = volume_db
	start_pitch = pitch_scale 

func play_usual():
	
	play()

func play_sfx():
	
	#volume_db = start_db + rand_range(-0.05, 0.05)
	pitch_scale = start_pitch * rand_range(0.93, 1.06)
	
	play()
