extends Node2D

onready var cursors = [$Red, $CursorPlant, $CursorAttack, $CursorWater1x1]

const TILE_PLANTABLE = 3

var may_play = false

func may_play_card():
	return may_play

func _ready():
	GS.cursor = self
	
func new_plant(associated_card):
	TutorialSteps.mark_have_planted()
	
	# My understanding is that these are reference types.
	if associated_card == GS.card_basic_plant:
		var p = GS.Plant1.instance()
		p.position = position
		get_parent().add_child(p)
		
func water(card):
	TutorialSteps.mark_have_watered()
	
	var sx = position.x
	var sy = position.y
	
	var width = 1
	var height = 1
	
	for i in range(0, width):
		for j in range(0, height):
			var x = sx + i * 128
			var y = sy + j * 128
			var plant = GS.get_plant_at_map_lcoord(Vector2(x, y))
			if plant != null:
				plant.water += 1
				
func attack(card):
	TutorialSteps.mark_have_attacked()
	
	var enemy = GS.get_enemy_at_map_lcoord(position)
	if enemy == null:
		return
		
	enemy.take_damage()
	
func defend(card):
	TutorialSteps.mark_have_defended()
	
	var plant = GS.get_plant_at_map_lcoord(position)
	if plant == null:
		return
		
	plant.apply_defense(card.quantity)

func get_tile():
	var p: TileMap = get_parent()
	
	# Our position is by definition local to the map coordinate space, so this
	# works great!
	var map_coord = p.world_to_map(position)
	
	return p.get_cellv(map_coord)
	
func is_tile_clear_and_type(tile_type):
	var obj = GS.get_object_at_map_lcoord(position)
	if obj != null:
		return false
		
	return get_tile() == tile_type
	
func is_tile_plant():
	var p = GS.get_plant_at_map_lcoord(position)
	return p != null
	
func is_tile_enemy():
	var e = GS.get_enemy_at_map_lcoord(position)
	return e != null
	
func show_water_cursor(card):
	if card.water_shape == GS.Water.W1x1:
		$CursorWater1x1.show()

func update_playable_and_display():
	for c in cursors:
		c.hide()
		
	#if GS.current_picked_up_card == null:
	if not is_instance_valid(GS.current_picked_up_card):
		return
		
	may_play = false
		
	var card = GS.current_picked_up_card.associated_card
	
	if card.action == GS.Action.PLANT:
		if is_tile_clear_and_type(TILE_PLANTABLE):
			$CursorPlant.show()
			may_play = true
	
	if card.action == GS.Action.WATER:
		if is_tile_plant():
			show_water_cursor(card)
			may_play = true
			
	if card.action == GS.Action.ATTACK:
		if is_tile_enemy():
			$CursorAttack.show()
			may_play = true
			
	if card.action == GS.Action.DEFEND:
		if is_tile_plant():
			$CursorPlant.show() # TODO: Defend
			may_play = true

func _physics_process(delta):
	var p = get_global_mouse_position()
	p = (p / 128).floor() * 128
	
	global_position = p #+ Vector2(32, 32)
	
	update_playable_and_display()
