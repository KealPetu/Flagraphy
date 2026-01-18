extends Control

var scene_to_load = "res://Scenes/Levels/LevelNorthAmerica.tscn" 

func _on_button_pressed():
	# Esta función cambia la escena actual por la nueva y borra la anterior de la memoria
	get_tree().change_scene_to_file(scene_to_load)
