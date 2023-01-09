extends Node

onready var card_1 = $Card1
onready var card_2 = $Card2
onready var card_3 = $Card3
onready var card_4 = $Card4
onready var card_play = $CardPlay

onready var whack = $Whack

onready var card_deal = $CardDeal

onready var button_hover = $ButtonHover
onready var button_click = $ButtonClick

onready var end_turn = $EndTurn

onready var plant_jingle = $PlantJingle
onready var no_water = $NoWater

onready var win_jingle = $WinJingle

func rand_card():
	var cards = [card_1, card_2, card_3, card_4]
	cards[randi() % cards.size()].play_sfx()

func rand_seeds():
	var s = [$Seed1, $Seed2]
	s[randi() % s.size()].play_sfx()

func rand_water():
	var s = [$Water1, $Water2]
	s[randi() % s.size()].play_sfx()
