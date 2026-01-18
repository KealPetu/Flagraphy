extends Control

@onready var volume_slider: HSlider = $ContenedorOpciones/HSliderVolumen
@onready var tts_check: CheckBox = $ContenedorOpciones/CheckBoxTTS
@onready var cb_enable_check: CheckBox = $ContenedorOpciones/CheckBoxDaltonismo
@onready var cb_type_option: OptionButton = $ContenedorOpciones/OpcionesDaltonismo
@onready var cb_intensity_slider: HSlider = $ContenedorOpciones/HSliderIntensidadDaltonismo
@onready var boton_regresar: Button = $ContenedorOpciones/BotonRegresar

func _ready():
	# 1. Cargar estado actual desde el GameManager (para que la UI coincida con la realidad)
	volume_slider.value = GameManager.master_volume
	tts_check.button_pressed = GameManager.tts_enabled
	
	# 2. Configurar lista de daltonismo
	cb_type_option.add_item("Protanopía (Rojo)")
	cb_type_option.add_item("Deuteranopía (Verde)")
	cb_type_option.add_item("Tritanopía (Azul)")
	
	# 3. Conectar señales (puede hacerse desde el editor también)
	volume_slider.value_changed.connect(_on_volume_changed)
	tts_check.toggled.connect(_on_tts_toggled)
	
	cb_enable_check.toggled.connect(_update_colorblind)
	cb_type_option.item_selected.connect(_update_colorblind_option) # Ojo: item_selected recibe un int
	cb_intensity_slider.value_changed.connect(_update_colorblind_slider)
	
	boton_regresar.pressed.connect(_on_back_button_pressed)

# --- FUNCIONES DE CONEXIÓN ---

func _on_volume_changed(value):
	GameManager.set_volume(value)

func _on_tts_toggled(toggled):
	GameManager.set_tts(toggled)

# Unificamos la lógica de daltonismo para llamar al GameManager
func _update_colorblind(_val = null):
	var is_active = cb_enable_check.button_pressed
	var type = cb_type_option.selected
	var intensity = cb_intensity_slider.value
	
	# Habilitar/Deshabilitar controles visualmente
	cb_type_option.disabled = not is_active
	cb_intensity_slider.editable = is_active
	
	GameManager.update_colorblind_settings(is_active, type, intensity)

# Wrappers pequeños porque las señales envían distintos argumentos
func _update_colorblind_option(_idx): _update_colorblind()
func _update_colorblind_slider(_val): _update_colorblind()

func _on_back_button_pressed():
	# Vuelve al menú principal (ajusta la ruta)
	get_tree().change_scene_to_file("res://Scenes/MenuPrincipal.tscn")
