class_name CardManager
extends Node

signal on_card_amount_change(num: int)

#var all_cards: Array[Card]
var cards_clicked: int

var faceup_cards: Array[Card]
var graveyard_card: Array[Card]
var cards_on_board: Array[Card]

var can_click: bool = false

var slots: Array[bool]

# Called when the node enters the scene tree for the first time.
func _ready():
	slots.resize(20)
	$TmrStartGame.start(5)
	
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
	print('manager ready')
	
	for i in range(20):
		add_a_card_to_borad()
		await get_tree().create_timer(0.2).timeout
	
	print(slots)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	##print(faceup_cards.size())

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
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
	
	if roll < 0.6: #60% chance
		return randi_range(1,4)
	elif roll < 0.8: #20% chance
		return Card.CARD_TYPE.BAD
	else: #10% chance
		return Card.CARD_TYPE.CLAEN


func add_a_card_to_borad() -> void:
	var next_up: Card = graveyard_card.pop_front()
	cards_on_board.push_back(next_up)
	next_up.setup(_gen_card_type())
	slots[next_up.slot] = true
	next_up.slide_to_position()
	next_up.is_on_board = true
	emit_signal("on_card_amount_change", cards_on_board.size())

func add_card_to_graveyard(c: Card) -> void:
	c.reset()
	slots[c.slot] = false
	c.is_on_board = true
	c.position = $Graveyard.position
	graveyard_card.push_back(c)
	cards_on_board.erase(c)
	emit_signal("on_card_amount_change", cards_on_board.size())
	print(slots)

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
	if cards_clicked < 2 and can_click:
		if faceup_cards.size() < 2:
			if !c.is_face_showing:
				cards_clicked += 1
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
		if faceup_cards[0].card_type == 6:
			pass
			#TODO: Remove one skull card
		if faceup_cards[0].card_type == 5:
			pass
			#TODO: Player matched skull
	else:
		$TmrFlipDelay.start()

func remove_card(c: Card) -> void:
	print(str("remove card: ", c.name))

func _on_tmr_flip_delay_timeout():
	put_cards_facedown()


func _on_tmr_start_game_timeout():
	
	var tween = get_tree().create_tween()
	tween.tween_property($LblStart, "scale", Vector2(1,1), 0.8)
	tween.tween_property($LblStart, "modulate:a", 0, 1)
	await tween.finished
	can_click = true
