extends CanvasLayer

@onready var screen: Control = $Screen
@onready var speaker: Label = $Screen/Speaker
@onready var message: Label = $Screen/Message

@export var message_duration: float = 2.0
@export var pause_between: float = 0.5


func _ready() -> void:
	screen.hide()
	speaker.text = "Mysterious Voice"


func say_line(text: String) -> void:
	message.text = text
	screen.show()

	await get_tree().create_timer(message_duration).timeout

	screen.hide()
	await get_tree().create_timer(pause_between).timeout
