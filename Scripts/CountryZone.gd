extends Panel

@export var target_country: String = "" # Ejemplo: "Canada"
signal flag_dropped_correctly

# Verifica si lo que arrastramos puede soltarse aquí
func _can_drop_data(at_position, data):
	# Solo aceptamos si trae datos de país
	return data.has("country")

# Qué pasa cuando soltamos la bandera
func _drop_data(at_position, data):
	var incoming_country = data["country"]
	
	if incoming_country == target_country:
		print("¡Correcto!")
		# Lógica visual: Poner la bandera dentro de este panel
		var flag = data["source_node"]
		flag.get_parent().remove_child(flag) # Quitar de la lista izquierda
		add_child(flag) # Agregar al mapa
		flag.position = Vector2.ZERO # Centrar o ajustar según necesidad
		
		# Deshabilitar arrastre de la bandera ya colocada (opcional)
		flag.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		# Emitir señal para subir puntaje
		flag_dropped_correctly.emit()
	else:
		print("Incorrecto, esa bandera no es de " + target_country)
