class_name Card
extends Node2D

signal was_clicked

enum CARD_TYPE {
	A = 1,
	B,
	C,
	D,
	BAD,
	CLAEN
}

var card_type: int
var is_face_showing: bool = false

const BACK_FRAME = 0
var front_frame: int = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup(type: int):
	self.card_type = type
	self.front_frame = card_type

func change_to_front():
	$Sprite2D.frame = self.front_frame

func change_to_back():
	$Sprite2D.frame = BACK_FRAME

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index==1:
		print(self.name)
		emit_signal("was_clicked")
