extends CanvasLayer

@onready var lbl_cards_left = $LblCardsLeft
@onready var lbl_pairs_left = $LblPairsLeft

var is_game_over: bool = false

func _ready():
	$GameOverOverlay.hide()
	$LblGameOver2.hide()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and is_game_over:
		print_debug("Reset Game")
		get_tree().reload_current_scene()

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
	$GameOverOverlay.show()
	$AnimationPlayer.play("drop_gameover")
	is_game_over = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "drop_gameover":
		$LblGameOver2.show()
