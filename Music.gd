extends Node

export var improv_nrg = 0.0

var pan_fx: AudioEffectPanner = null

var pan_direction = 1.0

func _ready():
	$Improv.play()
	$Drone.play()
	
	$Improv.volume_db = -100
	
	var improv_bus = AudioServer.get_bus_index("Improv")
	var fx: AudioEffectPanner = AudioServer.get_bus_effect(improv_bus, 0)
	
	pan_fx = fx
	
func _process(delta):
	if not $AnimationPlayer.is_playing():
		pan_direction = 1.0
		if randi() % 100 <= 50:
			pan_direction = -1.0 # Rnadom pan direction
		
		var length = rand_range(1.0, 3.5)
		$AnimationPlayer.play("AddImprov", 0, 1.0 / length)
		
	$Improv.volume_db = linear2db(improv_nrg)
	
	pan_fx.pan = lerp(-0.7 * pan_direction, 0.7 * pan_direction, improv_nrg)
