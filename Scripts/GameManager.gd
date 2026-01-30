extends CanvasLayer

# --- VARIABLES GLOBALES ---
var tts_enabled: bool = true # Por defecto activado
var master_volume: float = 1.0
var spanish_voice_id = ""

# Referencias al shader
@onready var color_rect = $Filtro

func _ready():
	# Inicializar shader apagado
	update_colorblind_settings(false, 0, 0.0)
	
	# --- CONFIGURACIÓN TTS GLOBAL ---
	_find_spanish_voice()
	
	# Conectamos la señal global del viewport que detecta cambios de foco
	get_viewport().gui_focus_changed.connect(_on_global_focus_changed)

func _find_spanish_voice():
	var voices = DisplayServer.tts_get_voices()
	for voice in voices:
		if voice["language"].begins_with("es"):
			spanish_voice_id = voice["id"]
			break

# --- DETECCIÓN AUTOMÁTICA DE FOCUS ---
func _on_global_focus_changed(control: Control):
	if not tts_enabled or control == null:
		return
	
	# Prioridad 1: Si el control tiene Tooltip, leemos eso.
	if control.tooltip_text != "":
		speak(control.tooltip_text)
	# Prioridad 2: Si es un botón y no tiene tooltip, leemos su texto visible.
	elif control is Button and control.text != "":
		speak(control.text)
	# Prioridad 3: Nombre del nodo (fallback)
	else:
		# Opcional: Descomentar si quieres que lea nombres de nodos, 
		# pero a veces es molesto si se llaman "PanelContainer2"
		# speak(control.name) 
		pass

# --- FUNCIÓN DE HABLA GENÉRICA ---
func speak(text: String):
	if not tts_enabled: return
	
	if DisplayServer.tts_is_speaking():
		DisplayServer.tts_stop()
		
	DisplayServer.tts_speak(text, spanish_voice_id)

# --- SETTINGS (Igual que antes) ---
func update_colorblind_settings(enabled: bool, mode: int, intensity: float):
	var material = color_rect.material as ShaderMaterial
	if not enabled:
		material.set_shader_parameter("mode", 0)
	else:
		material.set_shader_parameter("mode", mode + 1)
		material.set_shader_parameter("intensity", intensity)

func set_volume(value: float):
	master_volume = value
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(0, db_value)

func set_tts(enabled: bool):
	tts_enabled = enabled
	if not tts_enabled and DisplayServer.tts_is_speaking():
		DisplayServer.tts_stop()
