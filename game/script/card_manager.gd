class_name CardManager
extends Node

signal on_card_amount_change(num: int)

#var all_cards: Array[Card]
var cards_clicked: int

var faceup_cards: Array[Card]
var graveyard_card: Array[Card]
var cards_on_board: Array[Card]



# Called when the node enters the scene tree for the first time.
func _ready():
	new_game_shuffle()
	for c: Card in $Cards.get_children():
		c.connect("was_clicked", flip_over_card)
		c.connect("remove_me", add_card_to_graveyard)
		c.connect("done_flipping", add_to_array)
		cards_on_board.push_back(c)
		emit_signal("on_card_amount_change", cards_on_board.size())
	print('manager ready')
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game_shuffle() -> void:
	randomize()
	for c: Card in $Cards.get_children():
		c.setup(randi_range(1,4))

func _gen_card_type() -> int:
	randomize()
	var roll = randf()
	
	if roll < 0.6: #60% chance
		return randi_range(1,4)
	elif roll < 0.8: #20% chance
		return Card.CARD_TYPE.BAD
	else: #10% chance
		return Card.CARD_TYPE.CLAEN


func add_card_to_borad(pos: Vector2) -> void:
	var next_up: Card = graveyard_card.pop_front()
	next_up.setup(_gen_card_type())
	emit_signal("on_card_amount_change", cards_on_board.size())

func add_card_to_graveyard(c: Card) -> void:
	c.reset()
	c.position = $Graveyard.position
	graveyard_card.push_back(c)
	cards_on_board.erase(c)
	emit_signal("on_card_amount_change", cards_on_board.size())

func put_cards_facedown() -> void:
	cards_clicked = 0
	for c in faceup_cards:
		c.facedown()
	faceup_cards.clear()

func add_to_array(c: Card) -> void:
	faceup_cards.push_back(c)
	if faceup_cards.size() == 2:
		check_cards()

func are_all_cards_facedown() -> bool:
	var good: bool
	for c in self.cards_on_board:
		good = !c.is_face_showing
		if !good:
			return false
	return true 

func flip_over_card(c: Card) -> void:
	if cards_clicked < 2:
		cards_clicked += 1
		if faceup_cards.size() < 2:
			if !c.is_face_showing:
				c.faceup()

func check_cards() -> void:
	#TODO: Check if cards match 
				if faceup_cards[0].card_type == faceup_cards[1].card_type:
					print("they match")
					#TODO: Remove cards from board
					for card in faceup_cards:
						card.fade_away()
					faceup_cards.clear()
					cards_clicked = 0
				else:
					$TmrFlipDelay.start()

func remove_card(c: Card) -> void:
	print(str("remove card: ", c.name))

func _on_tmr_flip_delay_timeout():
	put_cards_facedown()
