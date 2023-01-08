extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GS.tilemap = self

func up1():
	for t in $Up1.get_used_cells():
		set_cellv(t, 3)
		
func up2():
	for t in $Up2.get_used_cells():
		set_cellv(t, 3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
