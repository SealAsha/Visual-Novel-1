extends CanvasLayer

@onready var screen: Control = $Screen
@onready var speaker: Label = $Screen/Speaker
@onready var message: Label = $Screen/Message

@export var starting_delay: float = 0.5
@export var message_duration: float = 4.0
@export var pause_between: float = 0.5


@export var dialogue_lines: Array[String] = [
	"ASHA! ASHA!",
	"OH MY GOD... OH MY GOD NO..",
	"WAKE UP,PLEASE WAKE UP", "...",
	"I'll find a way to fix this..."
]


func _ready() -> void:
	screen.hide()
	speaker.text = "You"
	play_dialogue()


func play_dialogue() -> void:
	await get_tree().create_timer(starting_delay).timeout

	for line in dialogue_lines:
		message.text = line
		screen.show()

		await get_tree().create_timer(message_duration).timeout

		screen.hide()

		await get_tree().create_timer(pause_between).timeout

	await fade_to_second()

func fade_to_second() -> void:
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

	get_tree().change_scene_to_file("res://2nd.tscn")
