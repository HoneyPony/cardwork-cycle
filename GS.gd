extends Node

enum Action {
	PLANT,
	WATER,
	ATTACK,
	DEFEND,
	DRAIN_WATER_DMG_RNG,
	DRAIN_WATER_DMG_ALL,
	HEAL_DMG_NEAR,
	DEF_DMG_NEAR,
	
	ADD_DAMAGE,
	
	DEF_ALL,
	HEAL_ALL_DMG,
	
	SACRIF,
	
	DRAW_3,
	PLUS_ENERGY
}

enum Water {
	W1x1,
	W2x2,
	W3x3
}

enum TurnState {
	UNDEFINED,
	WAITING_FOR_TUTORIAL,
	PLAYING_CARDS,
	UPDATING
}

const CAT_WATER = 1
const CAT_DEF = 2
const CAT_ATK = 3
const CAT_SEED = 4

var CardTexWater = preload("res://cards/card_water.svg")
var CardTexDef = preload("res://cards/card_tank.svg")
var CardTexAtk = preload("res://cards/card_attak.svg")
var CardTexSeed = preload("res://cards/card_seeds.svg")

var turn_state = TurnState.UNDEFINED
var waiting_for_card_selection = false

var card_selector_ui = null
var gold = 0
var energy = 3
var energy_max = 3

var shop_open = false
var upper_panel_mouse = false
var tutorial_mouse = false
var new_cards_mouse = false
var end_turn_mouse = false

func popup_card_selection(card_set: Array):
	waiting_for_card_selection = true
	card_selector_ui.setup_cards(card_set)
	card_selector_ui.popup()
	
func popup_card_winner():
	waiting_for_card_selection = true
	card_selector_ui.setup_win()
	card_selector_ui.popup()

class Card:
	var title: String
	var desc: String
	var cost: int
	var action
	
	var water_shape
	
	# Amount of damage, water, or defense
	var quantity
	
	# Amount of drain for health or water
	var drain
	
	var mult
	
	# Category / build, these things influence card generation
	var cat
	
	var icon
	
	func _init(title_: String, desc_: String, cost_: int, action_):
		title = title_
		desc = desc_
		cost = cost_
		action = action_
		
		quantity = 1
		drain = 1
		
		cat = 0
		icon = null
		
	func shape(water_shape_):
		water_shape = water_shape_
		return self
		
	func with_quantity(amount_):
		quantity = amount_
		return self
		
	func with_drain(amount_):
		drain = amount_
		return self
		
	func with_mult(m):
		mult = m
		return self
		
	func with_cat(c):
		cat = c
		return self
		
	func with_icon(ic):
		icon = ic
		return self

# The "global state" node. This is where global variables are usually stored,
# as well as things like scene preloads.

var card_basic_plant : Card = Card.new(
	"Basic Seeds",
	"Plant a basic plant that can be harvested for basic cards",
	1,
	Action.PLANT).with_cat(CAT_SEED).with_icon(preload("res://cards/icons/basic_seeds.svg"))
	
var card_medium_plant : Card = Card.new(
	"Middling Seeds",
	"Plant a plant that can be harvested for somewhat valuable cards",
	2,
	Action.PLANT).with_cat(CAT_SEED).with_icon(preload("res://cards/icons/middling_seeds.svg"))
	
var card_high_plant : Card = Card.new(
	"Quality Seeds",
	"Plant a plant that can be harvested for valuable cards",
	3,
	Action.PLANT).with_cat(CAT_SEED).with_icon(preload("res://cards/icons/quality_seeds.svg"))
	
var card_free_1x1_water : Card = Card.new(
	"Water Drop",
	"Apply 1 water to a 1x1 patch of tiles",
	0,
	Action.WATER
).shape(Water.W1x1).with_cat(CAT_WATER).with_icon(preload("res://cards/icons/water_drop.svg"))

var card_buy_1x1_water : Card = Card.new(
	"Water Drip",
	"Apply 1 water to a 1x1 patch of tiles",
	1,
	Action.WATER
).shape(Water.W1x1).with_cat(CAT_WATER).with_icon(preload("res://cards/icons/water_drip.svg"))

var card_small_attack : Card = Card.new(
	"Whack!",
	"Attack a single enemy for $DQ damage",
	1,
	Action.ATTACK
).with_quantity(1).with_cat(CAT_ATK).with_icon(preload("res://cards/icons/whack.svg"))

var card_small_defend : Card = Card.new(
	"Netting Shield",
	"Apply 1 immunity to a single plant",
	1,
	Action.DEFEND
).with_quantity(1).with_cat(CAT_DEF).with_icon(preload("res://cards/icons/netting_shield.svg"))

# Low water cards

var card_drain1_dmg3 : Card = Card.new(
	"Water Dagger",
	"Drain 1 water from a plant, and do $DQ damage to a random enemy",
	1,
	Action.DRAIN_WATER_DMG_RNG
).with_quantity(3).with_drain(1).with_cat(CAT_WATER).with_icon(preload("res://cards/icons/water_dagger.svg"))

var card_water2_1x1 : Card = Card.new(
	"Pour One",
	"Apply 2 water to a 1x1 square of tiles",
	1,
	Action.WATER
).shape(Water.W1x1).with_quantity(2).with_cat(CAT_WATER).with_icon(preload("res://cards/icons/pour_one.svg"))

var card_water1_2x2 : Card = Card.new(
	"Water Can",
	"Apply 1 water to a 2x2 square of tiles",
	3,
	Action.WATER
).shape(Water.W2x2).with_cat(CAT_WATER).with_icon(preload("res://cards/icons/water_can.svg"))

# Medium water cards

var card_water1_3x3 : Card = Card.new(
	"Water Barrel",
	"Apply 1 water to a 3x3 square of tiles",
	3,
	Action.WATER
).shape(Water.W3x3).with_cat(CAT_WATER).with_icon(preload("res://cards/icons/water_barrel.svg"))

var card_water2_2x2 : Card = Card.new(
	"Hose",
	"Apply 2 water to a 2x2 square of tiles",
	4,
	Action.WATER
).shape(Water.W2x2).with_quantity(2).with_cat(CAT_WATER).with_icon(preload("res://cards/icons/hose.svg"))

var card_drain3_rng5 : Card = Card.new(
	"Water Blast",
	"Drain 3 water from a plant, and do $DQ damage to a random enemy",
	2,
	Action.DRAIN_WATER_DMG_RNG
).with_drain(3).with_quantity(5).with_cat(CAT_WATER).with_icon(preload("res://cards/icons/water_blast.svg"))

# High water cards

var card_water5 : Card = Card.new(
	"Rainfall",
	"Apply 5 water to a single plant",
	3,
	Action.WATER
).shape(Water.W1x1).with_quantity(5).with_cat(CAT_WATER).with_icon(preload("res://cards/icons/rainfall.svg"))

var card_drain7_dmgall5 : Card = Card.new(
	"Tsunami",
	"Drain 5 water from a plant, and do $DQ damage to all enemies",
	4,
	Action.DRAIN_WATER_DMG_ALL
).with_quantity(5).with_drain(5).with_cat(CAT_WATER).with_icon(preload("res://cards/icons/tsunami.svg"))

var card_drain3_dmgall1 : Card = Card.new(
	"Overflow",
	"Drain 3 water from a plant, and do $DQ damage to all enemies",
	3,
	Action.DRAIN_WATER_DMG_ALL
).with_quantity(1).with_drain(3).with_cat(CAT_WATER).with_icon(preload("res://cards/icons/overflow.svg"))

# Low tank cards

var card_3def_1 : Card = Card.new(
	"Tough Shield",
	"Apply 3 immunity to a single plant",
	1,
	Action.DEFEND
).with_quantity(3).with_cat(CAT_DEF).with_icon(preload("res://cards/icons/tough_shield.svg"))

var card_heal1_dmg1 : Card = Card.new(
	"Vampire Fang",
	"Heal a plant for 1 health, and do $DQ damage to the nearest enemy",
	1,
	Action.HEAL_DMG_NEAR
).with_quantity(1).with_drain(1).with_cat(CAT_DEF).with_icon(preload("res://cards/icons/vampire_fang.svg")) # Drain is healing for this

var card_def2_dmg1 : Card = Card.new(
	"Spiked Shield",
	"Apply 2 immunity to a plant, and do $DQ damage to the nearest enemy",
	1,
	Action.DEF_DMG_NEAR
).with_quantity(1).with_drain(2).with_cat(CAT_DEF).with_icon(preload("res://cards/icons/spiked_shield.svg")) # Drain is healing for this # Drain is healing for this

# Medium tank cards

var card_heal2_dmg2 : Card = Card.new(
	"Vampire Slash",
	"Heal a plant for 2 health, and do $DQ damage to the nearest enemy",
	3,
	Action.HEAL_DMG_NEAR
).with_quantity(2).with_drain(2).with_cat(CAT_DEF).with_icon(preload("res://cards/icons/vampire_slash.svg")) # Drain is healing for this # Drain is healing for this

var card_def3_dmg3 : Card = Card.new(
	"Thorns",
	"Apply 3 immunity to a plant, and do $DQ damage to the nearest enemy",
	4,
	Action.DEF_DMG_NEAR
).with_quantity(3).with_drain(3).with_cat(CAT_DEF).with_icon(preload("res://cards/icons/thorns.svg")) # Drain is healing for this

# Rare tank cards: TODO

var card_def2_all : Card = Card.new(
	"Magic Shield",
	"Apply 2 immunity to all plants",
	4,
	Action.DEF_ALL
).with_quantity(2).with_cat(CAT_DEF).with_icon(preload("res://cards/icons/magic_shield.svg")) # Drain is healing for this

var card_heal_attack_all : Card = Card.new(
	"Vampire Blast",
	"Heal all plants for 2 health and do $DQ damage to all enemies",
	5,
	Action.HEAL_ALL_DMG
).with_drain(2).with_quantity(1).with_cat(CAT_DEF).with_icon(preload("res://cards/icons/vampire_blast.svg"))

# Low attack-focs cards

var card_dmg2 : Card = Card.new(
	"Kapow!",
	"Do $DQ damage to a single enemy",
	1,
	Action.ATTACK
).with_quantity(2).with_cat(CAT_ATK)

var card_add1_expensive: Card = Card.new(
	"Power Fungi",
	"Add 1 damage to your next attack",
	1,
	Action.ADD_DAMAGE
).with_quantity(1).with_cat(CAT_ATK)

var card_sacrif1_1enem : Card = Card.new(
	"Blood Dagger",
	"Take 1 plant health, and do $DQ damage to the lowest-health enemy.",
	1,
	Action.SACRIF
).with_quantity(5).with_drain(2).with_mult(1).with_cat(CAT_ATK)

# Medium attack cards

var card_add2 : Card = Card.new(
	"Technique",
	"Add 2 damage to your next attack",
	2,
	Action.ADD_DAMAGE
).with_quantity(2).with_cat(CAT_ATK)

var card_sacrif2_2enem : Card = Card.new(
	"Blood Blade",
	"Take 2 plant health, and do $DQ damage to the 2 lowest-health enemies.",
	3,
	Action.SACRIF
).with_quantity(5).with_drain(2).with_mult(2).with_cat(CAT_ATK)

var card_free_atk : Card = Card.new(
	"Zing!",
	"Attack an enemy for $DQ damage",
	0,
	Action.ATTACK
).with_quantity(1).with_cat(CAT_ATK)

# Rare attack cards

var card_add1_cheap : Card = Card.new(
	"Power Crystal",
	"Add 1 damage to your next attack",
	0,
	Action.ADD_DAMAGE
).with_quantity(1).with_cat(CAT_ATK)

var card_sacrifice : Card = Card.new(
	"Sacrifice",
	"Kill a plant, and do 5 damage to all enemies",
	5,
	Action.SACRIF
).with_quantity(5).with_drain(0).with_mult(-1).with_cat(CAT_ATK)

# GENERAL RARE CARDS

var card_win_plant : Card = Card.new(
	"Mystical Seeds",
	"Seeds for a plant that all farmers strive to one day grow",
	3,
	Action.PLANT
).with_cat(CAT_SEED)

var card_energy : Card = Card.new(
	"Free Energy",
	"Gain 1 ENERGY",
	0,
	Action.PLUS_ENERGY
)

# GENERAL MED CARDS

var card_cards : Card = Card.new(
	"Cool Drawing",
	"Draw 3 cards",
	1,
	Action.DRAW_3
)

var Game = preload("res://Game.tscn")
var MainMenu = preload("res://MainMenu.tscn")
var Intro = preload("res://Intro.tscn")
var HandCard = preload("res://cards/HandCard.tscn")
var CardBase = preload("res://cards/CardBase.tscn")

var Plant1 = preload("res://plants/plant1/Plant1.tscn")
var Plant2 = preload("res://plants/plant2/Plant2.tscn")
var Plant3 = preload("res://plants/plant3/Plant3.tscn")
var PlantWin = preload("res://plants/winplant/WinPlant.tscn")

var Bug = preload("res://bugs/Bug.tscn")

var hand = null

var current_picked_up_card = null
var cursor: Cursor = null

var tilemap = null

func set_current_card(card: Node):
	if current_picked_up_card != null:
		current_picked_up_card.release()
		current_picked_up_card = null
	current_picked_up_card = card
	
func release_current_card(card: Node):
	if current_picked_up_card == card:
		current_picked_up_card = null

func get_card_base(card: Card):
	var b = CardBase.instance()
	b.get_node("Title").text = card.title
	b.get_node("Desc").text = card.desc
	b.get_node("Cost").text = String(card.cost)
	b.associated_card = card
	return b
	
func spawn_bug_intcoord(x: int, y: int):
	var b = Bug.instance()
	
	tilemap.add_child(b)
	b.position = Vector2(x, y) * 128
	
func spawn_bug_lcoord(pos):
	var b = Bug.instance()
	tilemap.add_child(b)
	
	b.position = pos
	
	return b
	
func get_object_at_map_lcoord(coord: Vector2):
	for obj in get_tree().get_nodes_in_group("Object"):
		var p = obj.position
		if (p - coord).length_squared() < 16:
			return obj
	return null
	
func get_plant_at_map_lcoord(coord: Vector2):
	for obj in get_tree().get_nodes_in_group("Plant"):
		var p = obj.position
		if (p - coord).length_squared() < 16:
			return obj
	return null
	
func get_enemy_at_map_lcoord(coord: Vector2):
	for obj in get_tree().get_nodes_in_group("Enemy"):
		var p = obj.position
		if (p - coord).length_squared() < 16:
			return obj
	return null
	
func get_random_enemy():
	var nodes = get_tree().get_nodes_in_group("Enemy")
	
	return nodes[randi() % nodes.size()]
	
func get_nearest_enemy(position):
	var node = null
	var dist = 0
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var to_enem = (enemy.position - position).length()
		if node == null:
			node = enemy
			dist = to_enem
		elif to_enem < dist:
			node = enemy
			dist = to_enem
			
	return node
	
	
func get_lowest_health_enemy(exclude = null):
	var node = null
	var dist = 0
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy == exclude:
			continue
		
		if node == null:
			node = enemy
			dist = enemy.health
		elif enemy.health < dist:
			node = enemy
			dist = enemy.health
			
	return node


func add_card_to_hand(card: Card):
	var h = HandCard.instance()
	var b = get_card_base(card)
	
	b.dynamic_display = true
	
	h.associated_card = card
	
	h.add_child(b)
	
	hand.add_child(h)

func _ready():
	reset_all_state()
	
var current_turns = null
var current_obj = null
	
func turn_processor():
	for plant in get_tree().get_nodes_in_group("Plant"):
		current_obj = plant
		plant.take_turn()
		yield()
		
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		current_obj = enemy
		enemy.take_turn()
		yield()
		
	current_obj = null
	return null
	
enum SpawnOpt {
	Bug2,
	Bug3,
	Bug5,
	Bug9
}
var spawn_1bug2 = [SpawnOpt.Bug2]
var spawn_2bug2 = [SpawnOpt.Bug2, SpawnOpt.Bug2]
var spawn_3bug2 = [SpawnOpt.Bug2, SpawnOpt.Bug2, SpawnOpt.Bug2]
var spawn_2bug3 = [SpawnOpt.Bug3, SpawnOpt.Bug3]
var spawn_3bug3 = [SpawnOpt.Bug3, SpawnOpt.Bug3, SpawnOpt.Bug3]
var spawn_4bug3 = [SpawnOpt.Bug3, SpawnOpt.Bug3, SpawnOpt.Bug3, SpawnOpt.Bug3]
var spawn_bug5 = [SpawnOpt.Bug5]
var spawn_2bug5 = [SpawnOpt.Bug5, SpawnOpt.Bug5]
var spawn_3bug_w5 = [SpawnOpt.Bug5, SpawnOpt.Bug3, SpawnOpt.Bug3]
var spawn_bug9 = [SpawnOpt.Bug9, SpawnOpt.Bug2, SpawnOpt.Bug2]
var spawn_5bug = [SpawnOpt.Bug5, SpawnOpt.Bug5, SpawnOpt.Bug3, SpawnOpt.Bug2, SpawnOpt.Bug2]
var spawn_configs = [
	spawn_1bug2,
	spawn_1bug2,
	spawn_1bug2,
	spawn_2bug2,
	spawn_2bug2,
	spawn_2bug2,
	spawn_2bug2,
	spawn_3bug2,
	spawn_2bug2,
	spawn_2bug3,
	spawn_2bug3,
	spawn_3bug2,
	spawn_2bug3,
	spawn_3bug3,
	spawn_2bug3,
	spawn_2bug3,
	spawn_4bug3,
	spawn_2bug3,
	spawn_bug5,
	spawn_3bug3,
	spawn_bug5,
	spawn_2bug5,
	spawn_3bug3,
	spawn_2bug3,
	spawn_3bug_w5,
	spawn_3bug3,
	spawn_2bug5,
	spawn_3bug3,
	spawn_bug9,
	spawn_3bug3,
	spawn_2bug3,
	spawn_5bug,
	spawn_3bug3,
	spawn_3bug_w5,
	spawn_2bug3
]

var next_spawn = 0
	
func spawn_enemies():
	 # DEBUG
	
	var cfg = spawn_configs[next_spawn]
	# TODO: Keep using "difficult" configs
	next_spawn += 1
	if next_spawn > spawn_configs.size():
		next_spawn = 11 - 2 # Allow some easy
	
	# Enemies are spawned near plants
	var plants = get_tree().get_nodes_in_group("Plant")
	
	# Can't spawn if there are no plants, also wil cause div by zero
	if plants.size() == 0:
		return
	
	var count_enemys = get_tree().get_nodes_in_group("Enemy").size()
	
	# Three times
	for item in cfg:
		# Don't spawn more than 5 enemies at once
		if count_enemys + 1 >= 5:
			return
		
		# Try 100 times to spawn an enemy
		for attempt in range(0, 100):
			var p = plants[randi() % plants.size()]
			var x = (randi() % 5) - 2
			var y = (randi() % 5) - 2
			var pos = p.position + Vector2(x, y) * 128
			
			var existing = get_object_at_map_lcoord(pos)
			if existing == null:
				var bug = Bug.instance()
				bug.position = pos
				tilemap.add_child(bug)
				
				if item == SpawnOpt.Bug2:
					bug.health = 2
				if item == SpawnOpt.Bug5:
					bug.health = 5
				if item == SpawnOpt.Bug9:
					bug.heatlh = 9
				count_enemys += 1
				break
	
func end_turn():
	# Must be in PLAYING_CARDS or WAITING_FOR_TUTORIAL state
	if turn_state != TurnState.PLAYING_CARDS:
		return
	
	SFX.end_turn.play_sfx()
	
	hand.clear_hand()
	current_picked_up_card = null
	
	# You get 3 free turns between enemies...?
	if no_enemy_turns >= 3 or some_enemy_turns >= 12:
		spawn_enemies()
		# Give some bonus for fighting enemies
		no_enemy_turns = -int(some_enemy_turns / 2)
		some_enemy_turns = 0
	
	turn_state = TurnState.UPDATING
	current_turns = turn_processor()
	if current_turns == null:
		deal_new_hand()

# Used for plant markers!
var global_sine_timer = 0

func _process(delta):
	global_sine_timer += 0.4 * delta
	if global_sine_timer >= 1:
		global_sine_timer -= 1
		
var draw_pile = []
var discard_pile = []

var camera = null
	
func shuffle_cards():
	discard_pile.shuffle()
	draw_pile = discard_pile
	discard_pile = []
	
func draw_card():
	if not draw_pile.empty():
		return draw_pile.pop_front()
		
	if discard_pile.empty():
		return null
		
	shuffle_cards()
	return draw_pile.pop_front()
	
func draw_card_to_hand():
	var c = draw_card()
	if c == null:
		return
	add_card_to_hand(c)
	
var card_draw_count = 5
		
func deal_new_hand():
	if get_tree().get_nodes_in_group("Enemy").empty():
		no_enemy_turns += 1
	else:
		some_enemy_turns += 1
	
	TutorialSteps.mark_have_ended_turn()
	
	for plant in get_tree().get_nodes_in_group("Plant"):
		plant.set_defense(plant.defense - 1)
	
	for i in range(0, card_draw_count):
		var c = draw_card()
		if c == null:
			break
		add_card_to_hand(c)
	
	turn_state = TurnState.PLAYING_CARDS
	
	energy = energy_max
	
	SFX.card_deal.play_sfx()
		
func _physics_process(delta):
	if current_turns != null:
		if not is_instance_valid(current_obj):
			current_turns = current_turns.resume()
			
			if current_turns == null:
				deal_new_hand()
		elif current_obj.turn_over():
			current_obj.finalize_turn()
			current_turns = current_turns.resume()
			
			if current_turns == null:
				deal_new_hand()
				

func get_discard_pos():
	var s = get_viewport().size
	return camera.global_position + s * 0.5 + Vector2(0, 200)
	
# Should this get reset?
var tutorial = true

# Number of turns without any enemies...
# Enemies will be spawned regularly
var no_enemy_turns = 0

var some_enemy_turns = 0
	
func reset_all_state():
	tutorial = true # SHould this get reset?
	TutorialSteps.tutorial = null
	TutorialSteps.reset_all_state()
	
	CardCreation.reset_all_state()
	
	turn_state = TurnState.UNDEFINED
	waiting_for_card_selection = false

	card_selector_ui = null
	gold = 0
	
	energy_max = 3
	energy = energy_max
	
	hand = null

	current_picked_up_card = null
	cursor = null
	
	current_turns = null
	current_obj = null
	
	global_sine_timer = 0
	
	draw_pile = []
	discard_pile = []

	camera = null
	
	tilemap = null
	
	card_draw_count = 5 # Will be set by tutorial
	
	no_enemy_turns = 0
	some_enemy_turns = 0
	
	shop_open = false
	upper_panel_mouse = false
	tutorial_mouse = false
	new_cards_mouse = false
	end_turn_mouse = false
	
	next_spawn = 0
	if Flags.hard_mode:
		# Start with much harder bugs
		next_spawn = 12

