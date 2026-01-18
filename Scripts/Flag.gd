extends TextureRect

@export var country_name: String = "" 
@export_multiline var alt_text_description: String = "" # Texto extra para TTS: "Bandera de Canadá, hoja de arce roja"

var assigned_voice_id = ""

# Referencia al Nivel para avisar que me hicieron clic
# (Lo asignaremos al crear la bandera dinámicamente)
var level_manager = null

func _ready():
	# Detectar entrada del mouse para hover (opcional para usuarios que ven pero necesitan ayuda)
	mouse_entered.connect(_on_mouse_entered)

func _gui_input(event):
	# Detectar clic izquierdo
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if level_manager:
			level_manager.on_flag_clicked(self)

# --- FEEDBACK VISUAL ---
func select_visuals():
	# Opción A: Cambiar color (Modulate)
	modulate = Color(1.2, 1.2, 1.2) # La hace brillar
	# Opción B: Si tienes un nodo "ReferenceRect" como borde, hazlo visible
	# $Border.visible = true

func deselect_visuals():
	modulate = Color(1, 1, 1) # Vuelve a color normal
	# $Border.visible = false

func _on_mouse_entered():
	# Opcional: Leer al pasar el mouse por encima
	speak_text(country_name) 
	pass

func speak_text(text: String):
	# Verifica si el sistema soporta TTS
	if DisplayServer.tts_is_speaking():
		DisplayServer.tts_stop() # Detiene el audio anterior para no solaparse
	
	DisplayServer.tts_speak(text, assigned_voice_id)
