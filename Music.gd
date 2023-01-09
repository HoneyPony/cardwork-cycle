extends Node

export var improv_nrg = 0.0

var pan_fx: AudioEffectPanner = null

func _ready():
	$Improv.play()
	$Drone.play()
	
	$Improv.volume_db = -100
	
	var improv_bus = AudioServer.get_bus_index("Improv")
	var fx: AudioEffectPanner = AudioServer.get_bus_effect(improv_bus, 0)
	
	pan_fx = fx
	
func _process(delta):
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("AddImprov", 0, rand_range(0.3, 1.0))
		
	$Improv.volume_db = linear2db(improv_nrg)
	
	pan_fx.pan = lerp(-0.7, 0.7, improv_nrg)
