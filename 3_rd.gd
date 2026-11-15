extends Node2D
signal advance_dialogue

var waiting_for_next_line: bool = false

@onready var large_scientist: TextureRect = $scientist
@onready var player = $PlayerKnock
@onready var player_message: Label = $PlayerKnock/Screen/Message

@onready var scientist_screen: Control = $ScientistDialogue/Screen
@onready var scientist_name: Label = $ScientistDialogue/Screen/Speaker
@onready var scientist_message: Label = $ScientistDialogue/Screen/Message
@onready var portrait: TextureRect = $ScientistDialogue/Screen/TextureRect
@onready var house_background: TextureRect = $TextureRect
@onready var whiteboard_lesson: Control = $WhiteboardLesson
@onready var whiteboard: TextureRect = $WhiteboardLesson/Whiteboard
@onready var advance_hint: Label = $DialogueHint/Label
@onready var regulator_overlay: CanvasLayer = $RegulatorOverlay
@onready var orb_image: TextureRect = $RegulatorOverlay/Orb
@onready var scientist_reveal: TextureRect = $RegulatorOverlay/ScientistReveal
@onready var ending_fade: ColorRect = $EndingFade/Black

var whiteboard_images: Array[Texture2D] = [
	preload("res://photos/t1.png"),
	preload("res://photos/t2.png"),
	preload("res://photos/t3.png"),
	preload("res://photos/t4.png"),
	preload("res://photos/t5.png"),
	preload("res://photos/t6.png"),
	preload("res://photos/t7.png")
]

@export_range(0.05, 1.0, 0.05) var frame_duration: float = 0.2
@export var minimum_line_duration: float = 4.0
@export var seconds_per_character: float = 0.06
@export var pause_between: float = 0.4
@export var scientist_reveal_duration: float = 2.0
@export var ending_fade_duration: float = 1.5

var scientist_frames: Array[Texture2D] = [
	preload("res://photos/scientist1.png"),
	preload("res://photos/scientist2.png"),
	preload("res://photos/scientist3.png"),
	preload("res://photos/scientist4.png")
]

var scientist_talking: bool = false
var frame_index: int = 0
var frame_elapsed: float = 0.0


func _ready() -> void:
	player.set_dialogue_visible(false)
	scientist_screen.hide()
	whiteboard_lesson.hide()
	advance_hint.hide()
	regulator_overlay.hide()
	scientist_reveal.hide()
	ending_fade.hide()

	
	player_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scientist_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	scientist_message.set_anchors_preset(Control.PRESET_TOP_LEFT)
	scientist_message.position = Vector2(218, 494)
	scientist_message.size = Vector2(893, 112)

	set_scientist_frame(0)

	await get_tree().create_timer(0.5).timeout
	await play_conversation()
	await play_whiteboard_lesson()
	await play_regulator_conversation()
	await finish_regulator_scene()


func _process(delta: float) -> void:
	if not scientist_talking:
		return

	frame_elapsed += delta

	while frame_elapsed >= frame_duration:
		frame_elapsed -= frame_duration
		frame_index = (frame_index + 1) % scientist_frames.size()
		set_scientist_frame(frame_index)


func set_scientist_frame(index: int) -> void:
	
	large_scientist.texture = scientist_frames[index]
	portrait.texture = scientist_frames[index]


func say(who: String, text: String) -> void:
	player.set_dialogue_visible(false)
	scientist_screen.hide()

	frame_index = 0
	frame_elapsed = 0.0
	set_scientist_frame(0)
	scientist_talking = who == "Scientist"

	if who == "You":
		player_message.text = text
		player.set_dialogue_visible(true)
	else:

		scientist_name.text = who
		scientist_message.text = text
		portrait.visible = who == "Scientist"
		scientist_screen.show()

	
	advance_hint.show()
	waiting_for_next_line = true
	await advance_dialogue
	advance_hint.hide()
	
	scientist_talking = false
	set_scientist_frame(0)
	player.set_dialogue_visible(false)
	scientist_screen.hide()

	await get_tree().create_timer(pause_between).timeout


func play_conversation() -> void:
	await say("You", "I need to save her, I don’t care how you do it, just bring her back.")

	await say("Scientist", "And what exactly do you expect me to do? Resurrect the dead?")

	await say("You", "You told me you were researching time. You said you could change things!")

	await say("Scientist", "Ah. So you remember that conversation.")

	await say("", "He picks up a small elastic band from his desk.")

	await say("Scientist", "Have you ever stretched one of these?")

	await say("Scientist", "The further you stretch it, the more tension builds.
	 And when you release it—")

	await say("Scientist", "It returns.")

	await say("You", "What does that have to do with anything?")

	await say("Scientist", "Temporal Elasticity.")


func show_whiteboard(number: int) -> void:
	house_background.hide()
	large_scientist.hide()

	var board_texture: AtlasTexture = whiteboard.texture as AtlasTexture
	board_texture.atlas = whiteboard_images[number - 1]
	whiteboard_lesson.show()


func show_house() -> void:
	whiteboard_lesson.hide()
	house_background.show()
	large_scientist.show()


func play_whiteboard_lesson() -> void:

	var original_font_size: int = scientist_message.get_theme_font_size("font_size")
	scientist_message.add_theme_font_size_override("font_size", 22)

	show_whiteboard(6)
	await say("Scientist", "My theory proposes that time behaves much like an elastic material. It can be displaced, stretched and, under the right conditions, made to rebound.")

	show_whiteboard(5)
	await say("Scientist", "Now, imagine this point here represents the present.")

	show_whiteboard(4)
	await say("Scientist", "And this little fellow over here represents you.")

	show_whiteboard(3)
	await say("Scientist", "The important thing is that you've been displaced from your original temporal position. Think of time as an elastic structure. When you move backwards, you're effectively stretching that structure away from the present.")

	show_whiteboard(2)
	await say("Scientist", "This displacement generates what I call temporal momentum. It's the momentum accumulated through temporal retardation, or, more simply, backward displacement.")

	show_whiteboard(1)
	await say("Scientist", "These arrows represent the momentum generated as you move further away from your original present. The greater the displacement, the more momentum you need to accumulate.")
	await say("You", "So... I can go back?")
	await say("Scientist", "Theoretically.")
	await say("You", "Then do it. Send me back!")
	await say("Scientist", "You're not listening. There is a rather significant problem.")

	await say("Scientist", "Temporal displacement is not symmetrical. Returning forwards requires approximately five times the energy needed to retardate backwards.")
	await say("Scientist", "One backward displacement will not generate enough potential for a complete return.")
	await say("You", "So what am I supposed to do?")
	await say("Scientist", "Accumulate more.")
	await say("Scientist", "Each backward displacement contributes another increment of temporal momentum. You must accumulate five increments before you can generate sufficient momentum for a forward rebound.")
	await say("You", "A rebound?")
	await say("Scientist", "Think of stretching an elastic band. The further you stretch it, the more potential it stores. Release it, and it snaps back towards its original position.")
	await say("Scientist", "Temporal propulsion works on a similar principle. Once sufficient momentum has accumulated, the temporal structure can rebound, propelling you forwards towards your original coordinates.")

	show_house()
	scientist_message.add_theme_font_size_override("font_size", original_font_size)
	await say("You", "Time travel sounds impossible. How am I supposed to pull that off?")
	await say("Scientist", "Fortunately for you, I happen to have something that might make this possible.")


func play_regulator_conversation() -> void:

	whiteboard_lesson.hide()
	large_scientist.hide()
	orb_image.show()
	scientist_reveal.hide()
	regulator_overlay.show()
	var original_font_size: int = scientist_message.get_theme_font_size("font_size")
	scientist_message.add_theme_font_size_override("font_size", 22)

	await say("You", "What's that?")
	await say("Scientist", "This is a Temporal Regulator.")
	await say("Scientist", "It's a device designed to regulate temporal displacement. More importantly, it allows you to accumulate and store temporal momentum.")
	await say("You", "Temporal momentum...?")
	await say("Scientist", "Remember what I told you about Temporal Elasticity? Moving backwards stretches time, while moving forwards releases that accumulated tension.")
	await say("You", "Yeah...")
	await say("Scientist", "Well, this little thing makes that process possible.")
	await say("Scientist", "Here's how it'll work. You'll perform five successive backward displacements. Each time you travel backwards, you'll need to locate and collect a Temporal Shard.")
	await say("You", "A shard?")
	await say("Scientist", "Think of each one as a unit of temporal momentum. One displacement, one shard. Each shard contributes to the momentum required for your eventual forward propulsion.")
	await say("Scientist", "Your first displacement earns you one shard and so on, until you've accumulated all five.")
	await say("You", "And once I have all five?")
	await say("Scientist", "You use the regulator to release that accumulated momentum. The resulting temporal propulsion should propel you forwards, back towards your original present.")
	await say("You", "And that'll bring me back to the day Asha died?")
	await say("Scientist", "That's the theory.")
	await say("You", "Then I can stop it!")
	await say("Scientist", "Provided you survive long enough to do so.")
	await say("You", "What?")
	await say("Scientist", "There's a rather unpleasant side effect to prolonged temporal displacement.")
	await say("Scientist", "You see, the regulator is calibrated to your original temporal coordinates. It knows where you're supposed to be. When you travel backwards, it recognises that you're occupying a timeline that doesn't correspond to your original reference.")
	await say("Scientist", "The longer you remain displaced, the harder the regulator attempts to correct that discrepancy.")
	await say("You", "What happens if it does?")
	await say("Scientist", "Orb Infection.")
	await say("Scientist", "The regulator's energy begins interfering with your biological structure. You'll initially notice green particles appearing around your body, followed by green markings beneath your skin. As the infection progresses, those marks will spread.")
	await say("You", "That sounds...")
	await say("Scientist", "Unpleasant? It gets worse. Eventually, your body will begin to deteriorate. Once the infection reaches its terminal stage, you'll die.")
	await say("You", "...")
	await say("Scientist", "So I strongly advise against spending your afternoons sightseeing.")
	await say("You", "How long do I have?")
	await say("Scientist", "That depends. The regulator will monitor your condition and provide warnings, but I wouldn't recommend testing its limits.")
	await say("You", "I don't care. I'll do it.")
	await say("Scientist", "I was hoping you'd say that.")
	await say("Scientist", "Your first destination is three days before the incident. You'll need to find your first shard there.")
	await say("You", "And after that?")
	await say("Scientist", "Keep going backwards. Collect all five. Then come back.")
	await say("Scientist", "Simple enough, isn't it?")
	await say("You", "...I guess.")
	await say("Scientist", "Oh, and do try not to die. It would make all this rather embarrassing.")

	scientist_message.add_theme_font_size_override("font_size", original_font_size)


func finish_regulator_scene() -> void:
	waiting_for_next_line = false
	scientist_talking = false
	player.set_dialogue_visible(false)
	scientist_screen.hide()
	advance_hint.hide()
	orb_image.hide()
	scientist_reveal.show()
	await get_tree().create_timer(scientist_reveal_duration).timeout

	await say("Scientist", "Now, what are you waiting for?")
	await say("You", "Huh?")
	await say("Scientist", "Go on! Initiate your first temporal retardation!")

	ending_fade.color = Color(0, 0, 0, 0)
	ending_fade.show()
	var tween: Tween = create_tween()
	tween.tween_property(ending_fade, "color:a", 1.0, ending_fade_duration)
	await tween.finished


func _unhandled_input(event: InputEvent) -> void:
	if not waiting_for_next_line:
		return

	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode in [KEY_SPACE, KEY_ENTER, KEY_KP_ENTER]:
				waiting_for_next_line = false
				get_viewport().set_input_as_handled()
				advance_dialogue.emit()
