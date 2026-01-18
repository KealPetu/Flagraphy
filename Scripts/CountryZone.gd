extends Panel

@export var target_country: String = "" # Ejemplo: "Canada"
signal flag_dropped_correctly
# Verifica si lo que arrastramos puede soltarse aquí
func _can_drop_data(_at_position, data):
	# Solo aceptamos si trae datos de país
	return data.has("country")

# Qué pasa cuando soltamos la bandera
func _drop_data(_at_position, data):
	var incoming_country = data["country"]
	
	if incoming_country == target_country:
		print("¡Correcto!")
		
		# --- LÓGICA DE POSICIONAMIENTO Y TAMAÑO ---
		var flag = data["source_node"]
		
		# 1. Mover la bandera: Quitar de la lista y poner en este panel
		flag.get_parent().remove_child(flag) 
		add_child(flag) 
		
		# 2. Configurar el modo de escalado
		# "IGNORE_SIZE" permite que cambiemos el tamaño manualmente sin que la textura nos limite
		flag.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		flag.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED # Mantiene la proporción sin deformar
		
		# 3. Aplicar el nuevo tamaño
		if (size.x >= size.y):
			flag.size.y = size.y
			flag.custom_minimum_size.y = size.y
		else:
			flag.size.x = size.x
			flag.custom_minimum_size.x = size.x
		
		#flag.size = final_flag_size
		#flag.custom_minimum_size = final_flag_size # Forzamos el tamaño mínimo también por seguridad
		
		# 4. Centrar la bandera dentro del Panel
		# Esta función mágica de Godot 4 centra el objeto basándose en el tamaño del padre
		flag.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		
		# 5. Deshabilitar interacciones
		flag.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		# Emitir señal
		flag_dropped_correctly.emit()
	else:
		speak_feedback("Incorrecto")
		
func speak_feedback(text: String):
	# Verifica si el sistema soporta TTS
	if DisplayServer.tts_is_speaking():
		DisplayServer.tts_stop() # Detiene el audio anterior para no solaparse
	
	DisplayServer.tts_speak(text, "")
