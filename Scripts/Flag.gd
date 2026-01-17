extends TextureRect

@export var country_name: String = "" 
@export_multiline var alt_text_description: String = "" # Texto extra para TTS: "Bandera de Canadá, hoja de arce roja"

var assigned_voice_id = ""

func _ready():
	# Detectar entrada del mouse para hover (opcional para usuarios que ven pero necesitan ayuda)
	mouse_entered.connect(_on_mouse_entered)

func _get_drag_data(_at_position):
	# --- ACCESIBILIDAD ---
	# Leer el nombre al empezar a arrastrar
	speak_text("Arrastrando bandera de " + country_name)
	# ---------------------
	var preview = TextureRect.new()
	preview.texture = texture
	return { "source_node": self, "country": country_name }

func _on_mouse_entered():
	# Opcional: Leer al pasar el mouse por encima
	# speak_text(country_name) 
	pass

func speak_text(text: String):
	# Verifica si el sistema soporta TTS
	if DisplayServer.tts_is_speaking():
		DisplayServer.tts_stop() # Detiene el audio anterior para no solaparse
	
	# El id voice se puede buscar, pero dejarlo vacio usa la voz por defecto del sistema/navegador
	DisplayServer.tts_speak(text, assigned_voice_id)
