extends Node

class Card:
	var title: String
	var desc: String
	var cost: int
	
	func _init(title_: String, desc_: String, cost_: int):
		title = title_
		desc = desc_
		cost = cost_

# The "global state" node. This is where global variables are usually stored,
# as well as things like scene preloads.

var card_basic_plant : Card = Card.new("Basic Seeds", "Plant a basic plant that can be harvested for basic cards", 3)

var Game = preload("res://Game.tscn")
var MainMenu = preload("res://MainMenu.tscn")
var HandCard = preload("res://Cards/HandCard.tscn")
var CardBase = preload("res://Cards/CardBase.tscn")

var hand

func get_card_base(card: Card):
	var b = CardBase.instance()
	b.get_node("Title").text = card.title
	b.get_node("Desc").text = card.desc
	return b

func add_card_to_hand(card: Card):
	var h = HandCard.instance()
	var b = get_card_base(card)
	
	h.add_child(b)
	
	hand.add_child(h)

func _ready():
	pass

