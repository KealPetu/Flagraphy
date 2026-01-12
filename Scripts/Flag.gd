extends TextureRect

@export var country_name: String = "" # Ejemplo: "Canada"

# Esta función detecta cuando intentas arrastrar el objeto
func _get_drag_data(at_position):
	# 1. Crear una vista previa (lo que se ve pegado al mouse)
	var preview = TextureRect.new()
	preview.texture = texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.size = Vector2(50, 30) # Tamaño pequeño para arrastrar
	
	# 2. Configurar el control de vista previa
	var preview_control = Control.new()
	preview_control.add_child(preview)
	preview.position = -0.5 * preview.size # Centrar en el mouse
	set_drag_preview(preview_control)
	
	# 3. Retornar los datos que pasamos al soltar (la propia bandera y su nombre)
	return { "source_node": self, "country": country_name }
