class_name Card
extends Node2D

signal was_clicked(c: Card)
signal remove_me(c: Card)
signal done_flipping(c: Card)


enum CARD_TYPE {
	A = 1,
	B,
	C,
	D,
	BAD,
	CLAEN
}

const BACK_FRAME = 0

var card_type: int
var is_face_showing: bool = false
var front_frame: int = 1
var slot: int
var board_position: Vector2
var is_on_board: bool 


func _ready() -> void:
	$Area2D.mouse_entered.connect(_mosue_entered)

func reset() -> void:
	self.modulate.a = 225
	self.is_face_showing = false
	change_to_back()

func set_board_position(pos: Vector2):
	board_position = pos

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

func slide_to_position() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", board_position, 0.2)
	tween.tween_callback(on_board_placement)


func fake_shuffle() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(166,166), 1)
	await get_tree().create_timer(0.2).timeout
	await tween.finished
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "position", board_position, 1)
	tween2.tween_callback(on_board_placement)

func on_board_placement():
	pass

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index==1:
		emit_signal("was_clicked", self)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_away":
		emit_signal("remove_me", self)
	elif anim_name == "show_face":
		emit_signal("done_flipping", self)
	elif anim_name == "hide_face":
		self.is_face_showing = false

func _mosue_entered() -> void:
	print("mouse entered ", self.name)
