extends TextureRect

@export var float_distance: float = 5.0
@export var float_time: float = 2.5



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
