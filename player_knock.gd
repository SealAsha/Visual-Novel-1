extends CanvasLayer

@onready var box: Panel = $Screen/Box
@onready var speaker: Label = $Screen/Speaker
@onready var message: Label = $Screen/Message

@export var message_duration: float = 4.0
@export var pause_between: float = 0.5


func _ready() -> void:
	speaker.text = "You"
	set_dialogue_visible(false)


func set_dialogue_visible(show_dialogue: bool) -> void:
	box.visible = show_dialogue
	speaker.visible = show_dialogue
	message.visible = show_dialogue


func say_line(text: String) -> void:
	message.text = text
	set_dialogue_visible(true)

	await get_tree().create_timer(message_duration).timeout

	set_dialogue_visible(false)
	await get_tree().create_timer(pause_between).timeout
