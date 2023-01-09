extends Node

export var improv_nrg = 0

func _ready():
	$Improv.play()
	$Drone.play()
	
	$Improv.volume_db = -100
	
func _process(delta):
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("AddImprov", 0, rand_range(0.2, 1.0))
		
	$Improv.volume_db = linear2db(improv_nrg)
