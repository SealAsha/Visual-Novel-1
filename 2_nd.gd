extends Node2D

@onready var player = $PlayerKnock
@onready var voice = $MysteriousVoice
@onready var knock_button: Button = $Button

var conversation_started: bool = false


func _ready() -> void:

	$PlayerKnock/Screen.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_button_pressed() -> void:
	if conversation_started:
		return

	conversation_started = true
	knock_button.hide()

	await player.say_line("Hello? Is anyone there?")
	await voice.say_line("Ah.. there you are… I was wondering when you’d show up.")
	await player.say_line("Please... I need your help.")
	await voice.say_line("Door’s unlocked. You can come in~")
	await fade_to_third()

func fade_to_third() -> void:
	var fade_layer = CanvasLayer.new()
	fade_layer.layer = 100
	add_child(fade_layer)

	var black_screen = ColorRect.new()
	black_screen.color = Color(0, 0, 0, 0)
	fade_layer.add_child(black_screen)
	black_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var tween = create_tween()
	tween.tween_property(black_screen, "color:a", 1.0, 1.0)
	await tween.finished

	get_tree().change_scene_to_file("res://3_rd.tscn")
