extends Node2D

@onready var HUD = $HUD
@onready var card_mamager = $CardManager
# Called when the node enters the scene tree for the first time.
func _ready():
	print("game ready")
	card_mamager.connect("on_card_amount_change", HUD.update_cards_left)
	HUD.update_cards_left(card_mamager.cards_on_board.size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

