extends CanvasLayer

@onready var lbl_cards_left = $LblCardsLeft
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_cards_left(num:int) -> void:
	lbl_cards_left.text = str("Cards Left: ", num)
