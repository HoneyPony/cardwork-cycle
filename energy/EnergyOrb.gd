extends Node2D

onready var inner_spiral = $EnergyOrbInnerSpiral
onready var spiral = $EnergyOrbSpiral

func _physics_process(delta):
	inner_spiral.rotation += delta * TAU * 0.1
	spiral.rotation += delta * TAU * -0.05
