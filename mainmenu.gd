extends Node2D



func _ready() -> void:
	pass 



func _process(_delta: float) -> void:
	pass

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_start_2_pressed() -> void:
	get_tree().change_scene_to_file("res://loading_screen.tscn")
