extends Node


var all_cards: Array[Card]
var cards_clicked: int

var faceup_cards: Array[Card]



# Called when the node enters the scene tree for the first time.
func _ready():
	for c: Card in $Cards.get_children():
		c.connect("was_clicked", flip_over_card)
		c.connect("remove_me", remove_card)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func put_cards_facedown() -> void:
	cards_clicked = 0
	for c in faceup_cards:
		c.facedown()
	faceup_cards.clear()

func flip_over_card(c: Card) -> void:
	if cards_clicked < 2:
		if !c.is_face_showing:
			cards_clicked += 1
			c.faceup()
			faceup_cards.push_back(c)
			if cards_clicked == 2:
				#TODO: Check if cards match 
				if faceup_cards[0].card_type == faceup_cards[1].card_type:
					print("they match")
					#TODO: Remove cards from board
					for card in faceup_cards:
						card.fade_away()
				else:
					$TmrFlipDelay.start()
				

func remove_card(c: Card) -> void:
	print(str("remove card: ", c.name))

func _on_tmr_flip_delay_timeout():
	put_cards_facedown()
