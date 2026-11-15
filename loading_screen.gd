extends Control

const WORLD_PATH = "res://1_st.tscn"

@onready var loading_text: Label = \
	$CenterContainer/VBoxContainer/LoadingText

@onready var progress_bar: ProgressBar = \
	$CenterContainer/VBoxContainer/ProgressBar

var animation_time: float = 0.0


func _ready() -> void:
	set_process(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


	await RenderingServer.frame_post_draw

	var error = ResourceLoader.load_threaded_request(WORLD_PATH)

	if error != OK:
		show_loading_error()
		return

	set_process(true)


func _process(delta: float) -> void:
	
	animation_time += delta
	var dots = int(animation_time * 2.0) % 4
	loading_text.text = "Loading Game" + ".".repeat(dots)

	var progress: Array = []
	var status = ResourceLoader.load_threaded_get_status(
		WORLD_PATH, progress
	)

	if not progress.is_empty():
		progress_bar.value = progress[0] * 100.0

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)

		progress_bar.value = 100
		loading_text.text = "Entering Scene..."

		
		await RenderingServer.frame_post_draw

		var world_scene = ResourceLoader.load_threaded_get(
			WORLD_PATH
		) as PackedScene

		if world_scene == null:
			show_loading_error()
			return

		var error = get_tree().change_scene_to_packed(world_scene)

		if error != OK:
			show_loading_error()

	elif status == ResourceLoader.THREAD_LOAD_FAILED \
	or status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		show_loading_error()


func show_loading_error() -> void:
	set_process(false)
	loading_text.text = "Could not load the scene."
	push_error("Loading failed: " + WORLD_PATH)
