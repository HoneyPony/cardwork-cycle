extends Node2D


onready var base_x = position.x
onready var base_y = position.y

#
#func wind():
#	return sin(time * 0.12) * 3
	
func _process(delta):
#	rect_position.y = base + wind()
#	time += delta
	if randf() < 0.08:
		position.y = base_y + rand_range(-2, 2)
	if randf() < 0.08:
		position.x = base_x + rand_range(-2, 2)
