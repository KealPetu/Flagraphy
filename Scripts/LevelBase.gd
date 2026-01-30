class_name LevelBase extends Control

@export var level_name: String = "Nivel Genérico"
@onready var flag_container = $HSplitContainer/ScrollContainer/FlagContainer
@onready var map_container = $HSplitContainer/MapContainer
@onready var puntaje_label = $TopPanel/HBoxContainer/Puntaje
@onready var nivel_label: Label = $TopPanel/HBoxContainer/Nivel
@onready var boton_regresar: Button = $TopPanel/HBoxContainer/BotonRegresar
@onready var boton_reinicio: Button = $TopPanel/HBoxContainer/BotonReinicio

var flag_scene = preload("res://Scenes/Objects/Flag.tscn") # Ajusta tu ruta si cambió
const MENU_SELECCION = "res://Scenes/MenuSeleccion.tscn"

const POINTS_PER_COUNTRY = 10
var score = 0
var max_score = 0
var total_countries = 0
var selected_flag: Control = null

func _ready():
	nivel_label.text = level_name
	# Ya no buscamos voz aquí, lo hace GameManager
	
	setup_level()
	max_score = POINTS_PER_COUNTRY * total_countries
	puntaje_label.text = str(score) + "/" + str(max_score)
	
	# Solo conectamos acciones (pressed), no focus (lo maneja GameManager)
	boton_regresar.pressed.connect(cambiar_escena_menu_seleccion)
	boton_reinicio.pressed.connect(_on_reset_button_pressed)
	
	# Configurar Tooltips para los botones estáticos (Accesibilidad)
	boton_regresar.tooltip_text = "Regresar al menú de selección"
	boton_reinicio.tooltip_text = "Reiniciar el nivel actual"
	map_container.tooltip_text = "Mapa de juego. Selecciona una zona para colocar la bandera."
	# Asegúrate que el map_container tenga Focus Mode = All si quieres que se pueda seleccionar

func setup_level():
	var countries = map_container.get_children()
	for node in countries:
		if "target_country" in node: 
			node.level_manager = self
			# Configurar accesibilidad de la zona de caída
			node.tooltip_text = "Zona de " + node.target_country 
			node.focus_mode = Control.FOCUS_ALL # Importante para que detecte focus
			
			create_flag_for_country(node.target_country)
			total_countries += 1

func create_flag_for_country(country_name: String):
	var new_flag = flag_scene.instantiate()
	new_flag.country_name = country_name
	
	# --- ACCESIBILIDAD AUTOMÁTICA ---
	# Usamos el tooltip nativo. GameManager lo leerá automáticamente al enfocar.
	new_flag.tooltip_text = "Bandera de " + country_name
	new_flag.focus_mode = Control.FOCUS_ALL # Permitir navegación por teclado/clic
	# --------------------------------
	
	new_flag.level_manager = self
	
	var path = "res://Assets/Banderas/" + level_name + '/' + country_name + ".svg"
	if ResourceLoader.exists(path):
		new_flag.texture = load(path)	
	else:
		printerr("No se encontró imagen para: " + country_name)
	
	flag_container.add_child(new_flag)

# Funciones de lógica de juego (Clicks)
func on_flag_clicked(flag_node):
	if selected_flag != null:
		selected_flag.deselect_visuals()
	
	selected_flag = flag_node
	selected_flag.select_visuals() 
	
	# Feedback de ACCIÓN (no de foco, este se queda explícito)
	GameManager.speak("Seleccionada " + flag_node.country_name)

func on_zone_clicked(zone_node):
	if selected_flag == null:
		GameManager.speak("Primero selecciona una bandera.")
		return

	if selected_flag.country_name == zone_node.target_country:
		GameManager.speak("¡Correcto! " + zone_node.target_country)
		transfer_flag_to_zone(selected_flag, zone_node)
		selected_flag = null
		score += 10
		puntaje_label.text = str(score) + "/" + str(max_score)
		check_win_condition()
	else:
		GameManager.speak("Incorrecto. Esa zona es " + zone_node.target_country)

func transfer_flag_to_zone(flag, zone):
	flag.get_parent().remove_child(flag)
	zone.add_child(flag)
	
	# Lógica visual...
	flag.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	flag.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED 
	
	# Ajuste de tamaño...
	if zone.size.x >= zone.size.y:
		flag.size.y = zone.size.y
		flag.custom_minimum_size.y = zone.size.y
	else:
		flag.size.x = zone.size.x
		flag.custom_minimum_size.x = zone.size.x

	flag.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	
	# Al colocarla, quitamos el foco para que no moleste en la navegación
	flag.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flag.focus_mode = Control.FOCUS_NONE 
	flag.deselect_visuals()

func check_win_condition():
	if score == max_score:
		GameManager.speak("¡Nivel Completado!")

func _on_reset_button_pressed():
	get_tree().reload_current_scene()

func cambiar_escena_menu_seleccion():
	get_tree().change_scene_to_file(MENU_SELECCION)
