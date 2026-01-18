extends CanvasLayer

# --- VARIABLES GLOBALES ---
var tts_enabled: bool = false
var master_volume: float = 1.0

# Referencias al shader
@onready var color_rect = $Filtro

func _ready():
	# Inicializar shader apagado
	update_colorblind_settings(false, 0, 0.0)

# --- LÓGICA DE SETTINGS ---

func update_colorblind_settings(enabled: bool, mode: int, intensity: float):
	var material = color_rect.material as ShaderMaterial
	if not enabled:
		material.set_shader_parameter("mode", 0) # 0 es normal
	else:
		# Los modos en el OptionButton serán 0, 1, 2. En el shader son 1, 2, 3.
		# Así que sumamos 1 al modo que viene del menú.
		material.set_shader_parameter("mode", mode + 1)
		material.set_shader_parameter("intensity", intensity)

func set_volume(value: float):
	master_volume = value
	# Convertir valor lineal (0 a 1) a Decibeles para el AudioServer
	# Usamos el Bus 0 que suele ser el Master
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(0, db_value)

func set_tts(enabled: bool):
	tts_enabled = enabled
	if not tts_enabled and DisplayServer.tts_is_speaking():
		DisplayServer.tts_stop()
