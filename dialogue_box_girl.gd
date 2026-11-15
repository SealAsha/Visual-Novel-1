
extends CanvasLayer

@onready var box: Panel = $Screen/Box
@onready var portrait: TextureRect = $Screen/Portrait
@onready var speaker: Label = $Screen/Speaker
@onready var message: Label = $Screen/Message


@export var mouth_closed: Texture2D
@export var mouth_open: Texture2D


@export var starting_delay: float = 1.0
@export var message_duration: float = 4.0
@export var pause_between: float = 0.5
@export var talking_speed: float = 0.3


var dialogue_lines: Array[String] = [
	"Hey Hey Hey, don't you dare fall asleep right now!
	 Your driving!!",
	"I'm so excited to be going on this trip with you!!",
	"WATCH OUTT!"
]

var is_talking: bool = false


func _ready() -> void:
	box.hide()
	portrait.hide()
	speaker.hide()
	message.hide()

	speaker.text = "Asha"


	play_dialogue()



func play_dialogue() -> void:
	await get_tree().create_timer(starting_delay).timeout


	for line in dialogue_lines:
		box.show()
		portrait.show()
		speaker.show()
		message.show()
		message.text = line
		portrait.texture = mouth_closed
		is_talking = true
		animate_mouth()

		await get_tree().create_timer(message_duration).timeout


		is_talking = false
		portrait.texture = mouth_closed

 
		box.hide()
		portrait.hide()
		speaker.hide()
		message.hide()


		await get_tree().create_timer(pause_between).timeout

	
	await fade_to_dead()
func animate_mouth() -> void:
	while is_talking:
		portrait.texture = mouth_open
		await get_tree().create_timer(talking_speed).timeout

		if not is_talking:
			break

		portrait.texture = mouth_closed
		await get_tree().create_timer(talking_speed).timeout
	
func fade_to_dead() -> void:

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

	get_tree().change_scene_to_file("res://dead.tscn")
