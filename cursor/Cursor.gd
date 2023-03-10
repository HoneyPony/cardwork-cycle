extends Node2D
class_name Cursor

onready var cursors = [$Red, $CursorPlant, 
$CursorAttack, 
$CursorWater1x1, $CursorWater2x2, $CursorWater3x3,
 $CursorWaterDrain, $CursorGeneral,
$CursorDefense]

const TILE_PLANTABLE = 3

var may_play = false

var current_damage_add = 0

func damage(card):
	return card.quantity + current_damage_add

func reset_damage():
	current_damage_add = 0

func may_play_card():
	return may_play

func _ready():
	GS.cursor = self
	
func new_plant(associated_card):
	TutorialSteps.mark_have_planted()
	
	var scene = null
	
	# My understanding is that these are reference types.
	if associated_card == GS.card_basic_plant:
		scene = GS.Plant1
	if associated_card == GS.card_medium_plant:
		scene = GS.Plant2
	if associated_card == GS.card_high_plant:
		scene = GS.Plant3
	if associated_card == GS.card_win_plant:
		scene = GS.PlantWin
		
	if scene == null:
		return
		
	var p = scene.instance()
	p.position = position
	get_parent().add_child(p)
		
func water(card):
	TutorialSteps.mark_have_watered()
	
	var sx = position.x
	var sy = position.y
	
	var width = 1
	var height = 1
	
	if card.water_shape == GS.Water.W3x3:
		sx -= 128
		sy -= 128
		width = 3
		height = 3
	if card.water_shape == GS.Water.W2x2:
		width = 2
		height = 2
	
	for i in range(0, width):
		for j in range(0, height):
			var x = sx + i * 128
			var y = sy + j * 128
			var plant = GS.get_plant_at_map_lcoord(Vector2(x, y))
			if plant != null:
				plant.set_water(plant.water + card.quantity)
				
func attack(card):
	TutorialSteps.mark_have_attacked()
	
	var dmg = damage(card)
	reset_damage()
	
	var enemy = GS.get_enemy_at_map_lcoord(position)
	if enemy == null:
		return
		
	enemy.take_damage(dmg)
	
func defend(card):
	TutorialSteps.mark_have_defended()
	
	var plant = GS.get_plant_at_map_lcoord(position)
	if plant == null:
		return
		
	plant.set_defense(plant.defense + card.quantity)
	
func drain_water_dmg_rng(card):
	var plant = GS.get_plant_at_map_lcoord(position)
	if plant == null:
		return
		
	plant.set_water(plant.water - card.drain)
	
	var dmg = damage(card)
	reset_damage()
	
	var enemy = GS.get_random_enemy()
	if enemy == null:
		return
	enemy.take_damage(dmg)
	
func drain_water_dmg_all(card):
	var plant = GS.get_plant_at_map_lcoord(position)
	if plant == null:
		return
		
	plant.set_water(plant.water - card.drain) # TODO: ANIM
	
	var dmg = damage(card)
	reset_damage()
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.take_damage(dmg)
		
func heal_dmg_near(card):
	var plant = GS.get_plant_at_map_lcoord(position)
	if plant == null:
		return
		
	var dmg = damage(card)
	reset_damage()
	
	plant.set_health(plant.health + card.drain)
	
	var enemy = GS.get_nearest_enemy(position)
	if enemy == null:
		return
		
	enemy.take_damage(dmg)
	
func def_dmg_near(card):
	var plant = GS.get_plant_at_map_lcoord(position)
	if plant == null:
		return
		
	var dmg = damage(card)
	reset_damage()
	
	plant.set_defense(plant.defense + card.drain)
	
	var enemy = GS.get_nearest_enemy(position)
	if enemy == null:
		return
		
	enemy.take_damage(dmg)
	
func add_damage(associated_card):
	current_damage_add += associated_card.quantity
	
func def_all(associated_card):
	for plant in get_tree().get_nodes_in_group("Plant"):
		plant.set_defense(plant.defense + associated_card.quantity)

func heal_all_dmg(card):
	var dmg = damage(card)
	reset_damage()
	
	for plant in get_tree().get_nodes_in_group("Plant"):
		plant.set_health(plant.health + card.drain)
		
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.take_damage(dmg)
	
func sacrif(card):
	var plant = GS.get_plant_at_map_lcoord(position)
	if plant == null:
		return
		
	var amount = card.drain
	if amount == 0:
		amount = plant.health
	plant.set_health(plant.health - amount)
	
	var dmg = damage(card)
	reset_damage()
	
	if card.mult == -1:
		for enemy in get_tree().get_nodes_in_group("Enemy"):
			enemy.take_damage(dmg)
		return
	
	var enemy = GS.get_lowest_health_enemy()
	if enemy == null:
		return
		
	enemy.take_damage(dmg)
	
	if card.mult == 2:
		enemy = GS.get_lowest_health_enemy(enemy)
		if enemy == null:
			return
		enemy.take_damage(dmg)

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
	
func is_tile_water(amount):
	var p = GS.get_plant_at_map_lcoord(position)
	if p == null:
		return false
	return p.water >= amount
	
func is_tile_health(amount):
	var p = GS.get_plant_at_map_lcoord(position)
	if p == null:
		return false
	return p.health >= amount
	
func is_tile_enemy():
	var e = GS.get_enemy_at_map_lcoord(position)
	return e != null
	
func is_any_tile_plant_in_square(card):
	var sx = position.x
	var sy = position.y
	
	var width = 1
	var height = 1
	
	if card.water_shape == GS.Water.W3x3:
		sx -= 128
		sy -= 128
		width = 3
		height = 3
	if card.water_shape == GS.Water.W2x2:
		width = 2
		height = 2
		
	for i in range(0, width):
		for j in range(0, height):
			var x = sx + i * 128
			var y = sy + j * 128
			var plant = GS.get_plant_at_map_lcoord(Vector2(x, y))
			if plant != null:
				return true
	
	return false
	
func show_water_cursor(card):
	if card.water_shape == GS.Water.W1x1:
		$CursorWater1x1.show()
	if card.water_shape == GS.Water.W2x2:
		$CursorWater2x2.show()
	if card.water_shape == GS.Water.W3x3:
		$CursorWater3x3.show()

func update_playable_and_display():
	for c in cursors:
		c.hide()
		
	#if GS.current_picked_up_card == null:
	if not is_instance_valid(GS.current_picked_up_card):
		return
		
	may_play = false
	
	var snap = true
	
	# Must snap global position BEFORE looking at most kinds of cards.
	# Afterwards, we can restore unsnapped if needed.
	var unsnapped = global_position
	global_position = (global_position / 128).floor() * 128
		
	var card = GS.current_picked_up_card.associated_card
	
	if card.action == GS.Action.PLANT:
		if is_tile_clear_and_type(TILE_PLANTABLE):
			$CursorPlant.show()
			may_play = true
	
	if card.action == GS.Action.WATER:
		if is_any_tile_plant_in_square(card):
			show_water_cursor(card)
			may_play = true
		
			
	if card.action == GS.Action.ATTACK:
		if is_tile_enemy():
			$CursorAttack.show()
			may_play = true
			
	if card.action == GS.Action.DEFEND \
		or card.action == GS.Action.HEAL_DMG_NEAR \
		or card.action == GS.Action.DEF_DMG_NEAR:
		if is_tile_plant():
			$CursorDefense.show() # TODO: Defend
			may_play = true
			
	if card.action == GS.Action.DRAIN_WATER_DMG_RNG \
		or card.action == GS.Action.DRAIN_WATER_DMG_ALL:
		if is_tile_water(card.drain):
			$CursorWaterDrain.show()
			may_play = true
			
	if card.action == GS.Action.SACRIF:
		if is_tile_health(card.drain):
			$CursorAttack.show()
			may_play = true
			
	if card.action == GS.Action.ADD_DAMAGE \
		or card.action == GS.Action.DEF_ALL \
		or card.action == GS.Action.HEAL_ALL_DMG \
		or card.action == GS.Action.DRAW_3 \
		or card.action == GS.Action.PLUS_ENERGY:
		var bottom = GS.camera.global_position.y + get_viewport().size.y * 0.5
		var thresh = bottom - 360
		
		snap = false
		
		if get_global_mouse_position().y < thresh:
			$CursorGeneral.show()
			may_play = true
			
			
	if not snap:
		global_position = unsnapped

func _physics_process(delta):
	var p = get_global_mouse_position()
	
	global_position = p #+ Vector2(32, 32)
	
	update_playable_and_display()
