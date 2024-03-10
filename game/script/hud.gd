extends CanvasLayer

@onready var lbl_cards_left = $LblCardsLeft
@onready var lbl_pairs_left = $LblPairsLeft


func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func update_cards_left(num:int) -> void:
	lbl_cards_left.text = str("Cards Left: ", num)

func update_pair_label(num:int) -> void:
	lbl_pairs_left.text = str("Pairs Left: ", num)

func update_card_labels(cards: Array[Card]) -> void:
	if cards.size() == 0:
		$lblCard_1.text = str("Card 1: ")
		$lblCard_2.text = str("Card 2: ")
	elif cards.size() == 1:
		$lblCard_1.text = str("Card 1: ", cards[0].name)
	elif cards.size() == 2:
		$lblCard_2.text = str("Card 2: ", cards[1].name)
	
func show_game_over() -> void:
	$AnimationPlayer.play("drop_gameover")
