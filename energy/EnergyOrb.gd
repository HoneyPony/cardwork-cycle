extends Node2D

onready var inner_spiral = $EnergyOrbInnerSpiral
onready var spiral = $EnergyOrbSpiral

var energy_indicator

func _ready():
	energy_indicator = GS.energy

func _physics_process(delta):
	inner_spiral.rotation += delta * TAU * 0.1
	spiral.rotation += delta * TAU * -0.05
	
	energy_indicator += (GS.energy - energy_indicator) * 0.2
	$Num.text = String(int(round(energy_indicator)))
