extends Node2D

@onready var HUD = $HUD
@onready var card_mamager = $CardManager
# Called when the node enters the scene tree for the first time.

const NEEDED_PAIRS: int = 20
var pairs_left: int

func _ready():
	pairs_left = NEEDED_PAIRS
	print("game ready")
	card_mamager.connect("on_card_amount_change", HUD.update_cards_left)
	card_mamager.connect("pair_made", lower_pairs_left)
	card_mamager.connect("card_flipped_over", HUD.update_card_labels)
	HUD.update_cards_left(card_mamager.cards_on_board.size())
	HUD.update_pair_label(pairs_left)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func lower_pairs_left() -> void:
	pairs_left -= 1
	HUD.update_pair_label(pairs_left)
