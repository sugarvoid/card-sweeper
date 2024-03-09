class_name Card
extends Node2D

signal was_clicked(c: Card)
signal remove_me(c: Card)

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

func reset() -> void:
	self.modulate.a = 225

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup(type: int):
	self.card_type = type
	self.front_frame = card_type

func faceup() -> void:
	$AnimationPlayer.play("show_face")

func facedown() -> void:
	$AnimationPlayer.play("hide_face")

func fade_away() -> void:
	#TODO: Replace with an animation 
	$AnimationPlayer.play("fade_away")

func change_to_front():
	$Sprite2D.frame = self.front_frame
	self.is_face_showing = true

func change_to_back():
	$Sprite2D.frame = BACK_FRAME
	self.is_face_showing = true

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index==1:
		print(self.name)
		emit_signal("was_clicked", self)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_away":
		emit_signal("remove_me", self)
