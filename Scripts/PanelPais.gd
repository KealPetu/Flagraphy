extends Panel

@export var target_country: String = "" # Ejemplo: "Canada"
var final_flag_size: Vector2 = Vector2(64, 40)

# Buscamos al "jefe" (LevelBase) subiendo en el árbol. 
# Como CountryZone es hijo del mapa, y el mapa hijo del nivel...
@onready var level_manager = find_parent("LevelBase*") # El * busca nodos que empiecen con ese nombre, o usa get_tree().current_scene si es la raiz

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Si ya tengo un hijo (bandera colocada), ignorar clics
		if get_child_count() > 0: 
			return
			
		if level_manager:
			level_manager.on_zone_clicked(self)

func speak_feedback(text: String):
	# Verifica si el sistema soporta TTS
	if DisplayServer.tts_is_speaking():
		DisplayServer.tts_stop() # Detiene el audio anterior para no solaparse
	
	DisplayServer.tts_speak(text, "")
