extends Node2D

onready var cursors = [$Red, $CursorPlant]

const TILE_PLANTABLE = 3

func get_tile():
	var p: TileMap = get_parent()
	
	# Our position is by definition local to the map coordinate space, so this
	# works great!
	var map_coord = p.world_to_map(position)
	
	return p.get_cellv(map_coord)

func choose_display():
	for c in cursors:
		c.hide()
		
	if GS.current_picked_up_card == null:
		return
		
	var card = GS.current_picked_up_card.associated_card
	
	if card.action == GS.Action.PLANT:
		if get_tile() == TILE_PLANTABLE:
			$CursorPlant.show()

func _physics_process(delta):
	var p = get_global_mouse_position()
	p = (p / 64).floor() * 64
	
	global_position = p #+ Vector2(32, 32)
	
	choose_display()
