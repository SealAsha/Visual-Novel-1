extends TextureRect

@export var float_distance: float = 5.0
@export var float_time: float = 2.5


@export var scientist1: Texture2D
@export var scientist2: Texture2D
@export var scientist3: Texture2D
@export var scientist4: Texture2D


func _ready() -> void:
	var starting_y = position.y

	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	# Gently move upwards.
	tween.tween_property(
		self,
		"position:y",
		starting_y - float_distance,
		float_time
	)


	tween.tween_property(
		self,
		"position:y",
		starting_y,
		float_time
	)


func _on_exit_pressed() -> void:
	pass 


func _on_start_pressed() -> void:
	pass
