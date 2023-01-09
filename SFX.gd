extends Node

onready var card_1 = $Card1
onready var card_2 = $Card2
onready var card_3 = $Card3
onready var card_4 = $Card4
onready var card_play = $CardPlay

func rand_card():
	var cards = [card_1, card_2, card_3, card_4]
	cards[randi() % cards.size()].play_sfx()
