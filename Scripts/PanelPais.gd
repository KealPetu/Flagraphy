extends Panel

@export var target_country: String = ""
var level_manager = null # Se inyecta desde LevelBase

func _gui_input(event):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or event.is_action_pressed("ui_accept"):
		if get_child_count() > 0: return # Ya tiene bandera
			
		if level_manager:
			level_manager.on_zone_clicked(self)
			accept_event()
