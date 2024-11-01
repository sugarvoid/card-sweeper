class_name CardManager
extends Node

signal on_card_amount_change(num: int)
signal pair_made
signal card_flipped_over(c:Card)
signal on_gameover

const NORMAL_CHANCE = 0.70
const SKULL_CHANCE = 0.20
const CROSS_CHANCE = 0.10

var cards_clicked: int
var faceup_cards: Array[Card]
var graveyard_card: Array[Card]
var cards_on_board: Array[Card]
var can_click: bool = false
var slots: Array[bool]
var card_amounts: Dictionary = {
	"1" : 0,
	"2" : 0,
	"3" : 0,
	"4" : 0,
	"5" : 0,
	"6" : 0,
}


func _ready() -> void:
	slots.resize(20)
	## $TmrStartGame.start(5)
	new_game_shuffle()
	for c: Card in $Cards.get_children():
		add_card_to_graveyard(c)
		var card_num: int = int(c.name.substr(4,2).strip_edges())
		c.slot = card_num
		c.set_board_position(get_board_pos(card_num))
		c.connect("was_clicked", flip_over_card)
		c.connect("remove_me", add_card_to_graveyard)
		c.connect("done_flipping", add_to_array)
		emit_signal("on_card_amount_change", cards_on_board.size())
	
	card_amounts = reset_dic()
	
	for i in range(20):
		add_a_card_to_borad()
		await get_tree().create_timer(0.1).timeout
		
	print(card_amounts)
	_on_tmr_start_game_timeout()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		#TODO: Don't count the cards in graveyard
		#TODO: Actaully shuffle the card positions
		for c: Card in $Cards.get_children():
			c.fake_shuffle()


func get_board_pos(slot: int) -> Vector2:
	return $CardPositions.get_child(slot).position
	
	
func new_game_shuffle() -> void:
	randomize()
	for c: Card in $Cards.get_children():
		c.setup(randi_range(1,4))
	

func _gen_card_type() -> int:
	randomize()
	var roll = randf()
	# print(roll)
	if roll <= NORMAL_CHANCE:
		#print("normal")
		return randi_range(1,4)
	elif roll > NORMAL_CHANCE && roll <= (NORMAL_CHANCE + SKULL_CHANCE):
		#print("skull")
		return Card.CARD_TYPE.BAD
	elif roll > (NORMAL_CHANCE + SKULL_CHANCE):
		#print("cross")
		return Card.CARD_TYPE.CLAEN
	return -99


func add_a_card_to_borad() -> void:
	var next_up: Card = graveyard_card.pop_front()
	cards_on_board.push_back(next_up)
	next_up.setup(_gen_card_type())
	card_amounts[str(next_up.card_type)] += 1
	slots[next_up.slot] = true
	next_up.slide_to_position()
	next_up.is_on_board = true
	emit_signal("on_card_amount_change", cards_on_board.size())

func add_card_to_graveyard(c: Card) -> void:
	c.reset()
	slots[c.slot] = false
	c.is_on_board = true
	c.position = $Graveyard.position
	card_amounts[str(c.card_type)] -= 1
	graveyard_card.push_back(c)
	cards_on_board.erase(c)
	emit_signal("on_card_amount_change", cards_on_board.size())
	if cards_on_board.size() == 12:
		graveyard_card.shuffle()
		for _x in graveyard_card.size():
			add_a_card_to_borad()

func put_cards_facedown() -> void:
	cards_clicked = 0
	for c in faceup_cards:
		c.facedown()
	faceup_cards.clear()
	emit_signal("card_flipped_over", faceup_cards)

func add_to_array(c: Card) -> void:
	faceup_cards.push_back(c)
	emit_signal("card_flipped_over", faceup_cards)
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
	if faceup_cards.size() < 2 and can_click and cards_clicked < 2:
		can_click = false
		if !c.is_face_showing:
			cards_clicked += 1
			c.faceup()
			await get_tree().create_timer(0.2).timeout
			can_click = true

func check_cards() -> void:
	cards_clicked = 0
	if faceup_cards[0].card_type == faceup_cards[1].card_type:
		print("they match")
		can_click = false
		if faceup_cards[0].card_type == 6:
			for card in cards_on_board:
				if card.card_type == Card.CARD_TYPE.BAD:
					card.faceup()
					await get_tree().create_timer(0.3).timeout
					card.fade_away()
					remove_match()
					return
		if faceup_cards[0].card_type == 5:
			#TODO: Instead of gameover, just shuffle the cards
			emit_signal("on_gameover")
			return
		remove_match()
		emit_signal("card_flipped_over", faceup_cards)
		await get_tree().create_timer(0.5).timeout
		can_click = true
	else:
		$TmrFlipDelay.start()

func remove_match() -> void:
	for card in faceup_cards:
		card.fade_away()
	faceup_cards.clear()

#func remove_card(c: Card) -> void:
	#print(str("remove card: ", c.name))

func _on_tmr_flip_delay_timeout():
	put_cards_facedown()


func _on_tmr_start_game_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property($LblStart, "scale", Vector2(1,1), 0.8)
	tween.tween_property($LblStart, "modulate:a", 0, 1)
	await tween.finished
	can_click = true

func update_card_list() -> void:
	for card in cards_on_board:
		card_amounts[str(card.card_type)] += 1

func reset_dic() -> Dictionary:
	var card_amounts: Dictionary = {
	"1" : 0,
	"2" : 0,
	"3" : 0,
	"4" : 0,
	"5" : 0,
	"6" : 0,
	}
	
	return card_amounts
