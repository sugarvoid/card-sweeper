extends CanvasLayer

@onready var lbl_cards_left = $LblCardsLeft
# Called when the node enters the scene tree for the first time.
@onready var lbl_pairs_left = $LblPairsLeft
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_cards_left(num:int) -> void:
	lbl_cards_left.text = str("Cards Left: ", num)

func update_pair_label(num:int) -> void:
	lbl_pairs_left.text = str("Pairs Left: ", num)
