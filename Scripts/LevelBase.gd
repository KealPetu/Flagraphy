class_name LevelBase extends Control # class_name permite que otros scripts sepan qué es esto

@export var level_name: String = "Nivel Genérico"
@onready var flag_container = $HSplitContainer/ScrollContainer/FlagContainer
@onready var map_container = $HSplitContainer/MapContainer
@onready var puntaje_label = $TopPanel/HBoxContainer/Puntaje
@onready var nivel_label: Label = $TopPanel/HBoxContainer/Nivel
@onready var boton_regresar: Button = $TopPanel/HBoxContainer/BotonRegresar
@onready var boton_reinicio: Button = $TopPanel/HBoxContainer/BotonReinicio


# Referencia a la escena de la bandera para instanciarla dinámicamente
var flag_scene = preload("res://Scenes/Objects/Flag.tscn")
const MENU_SELECCION = "res://Scenes/MenuSeleccion.tscn"

const POINTS_PER_COUNTRY = 10
var score = 0
var max_score = 0
var total_countries = 0
var spanish_voice_id = ""
var selected_flag: Control = null

func _ready():
	nivel_label.text = level_name
	_find_spanish_voice()
	setup_level()
	max_score = POINTS_PER_COUNTRY * total_countries
	puntaje_label.text = str(score) + "/" + str(max_score)
	
	# Conexion de Señales
	# Control de escenas
	boton_regresar.pressed.connect(cambiar_escena_menu_seleccion)
	boton_reinicio.pressed.connect(_on_reset_button_pressed)
	
	# Control TTS
	boton_regresar.focus_entered.connect(_on_boton_regresar_focus_entered)
	boton_reinicio.focus_entered.connect(_on_boton_reinicio_focus_entered)
	map_container.focus_entered.connect(_on_map_container_focused)

func _find_spanish_voice():
	var voices = DisplayServer.tts_get_voices()
	
	# Imprimir para depurar (mira la consola para ver qué detecta tu navegador)
	print("Voces disponibles: ", voices)
	
	for voice in voices:
		# Buscamos cualquier voz que empiece con "es" (es_ES, es_MX, etc.)
		if voice["language"].begins_with("es"):
			spanish_voice_id = voice["id"]
			print("Voz en español seleccionada: ", voice["name"])
			break

func setup_level():
	var countries = map_container.get_children()
	
	for node in countries:
		# 1. Conectar Zonas (Mapa)
		# Aseguramos que el nodo tenga la señal gui_input o lo conectamos manualmente
		# Nota: Como _gui_input es interna, mejor creamos una señal en CountryZone o usamos una lambda aquí.
		# Pero para mantenerlo simple con el script de arriba, vamos a inyectar la referencia.
		
		if "target_country" in node: # Verifica si es una CountryZone
			node.level_manager = self # ¡Aquí le decimos quién es el jefe!
			create_flag_for_country(node.target_country)
			total_countries += 1

func create_flag_for_country(country_name: String):
	var new_flag = flag_scene.instantiate()
	new_flag.country_name = country_name
	new_flag.assigned_voice_id = spanish_voice_id
	new_flag.level_manager = self
	# Ejemplo: "Canada" busca "res://Assets/Banderas/Norte America/Canada.svg"
	var path = "res://Assets/Banderas/" + level_name + '/' + country_name + ".svg"
	if ResourceLoader.exists(path):
		new_flag.texture = load(path)	
	else:
		printerr("No se encontró imagen para: " + country_name)
	
	# Texto alternativo para accesibilidad
	new_flag.alt_text_description = "Bandera de " + country_name
	
	flag_container.add_child(new_flag)

func speak_feedback(text):
	if DisplayServer.tts_is_speaking():
		DisplayServer.tts_stop()
	# Pasamos 'spanish_voice_id' como segundo argumento
	DisplayServer.tts_speak(text, spanish_voice_id)

func check_win_condition():
	if score == max_score: # 3 países x 10 puntos
		print("¡Nivel Completado!")

func _on_reset_button_pressed():
	get_tree().reload_current_scene() # Reinicia el nivel

func _on_boton_regresar_focus_entered() -> void:
	speak_feedback("Botón de regresar")

func _on_boton_reinicio_focus_entered() -> void:
	speak_feedback("Botón de reinicio")

func _on_map_container_focused() -> void:
	speak_feedback(map_container.accessibility_name)

func cambiar_escena_menu_seleccion():
	get_tree().change_scene_to_file(MENU_SELECCION)
	pass
	
func on_flag_clicked(flag_node):
	# 1. Si ya había una seleccionada, le quitamos el brillo/borde
	if selected_flag != null:
		selected_flag.deselect_visuals()
	
	# 2. Guardamos la nueva selección
	selected_flag = flag_node
	selected_flag.select_visuals() # Función visual que crearemos en la bandera
	
	# 3. Feedback de audio
	speak_feedback("Seleccionada bandera de " + flag_node.country_name)

func on_zone_clicked(zone_node):
	# 1. Verificar si tenemos algo seleccionado
	if selected_flag == null:
		speak_feedback("Primero selecciona una bandera.")
		return

	# 2. Verificar si coincide
	if selected_flag.country_name == zone_node.target_country:
		# --- CORRECTO ---
		speak_feedback("¡Correcto! " + zone_node.target_country)
		
		# Mover visualmente la bandera al mapa
		transfer_flag_to_zone(selected_flag, zone_node)
		
		# Limpiar selección
		selected_flag = null
		score += 10
		# (Actualizar puntaje label aquí)
		puntaje_label.text = str(score) + "/" + str(max_score)
		check_win_condition()

	else:
		# --- INCORRECTO ---
		speak_feedback("Incorrecto. Esa bandera no es de " + zone_node.target_country)
		# Opcional: Restar puntos o feedback visual de error

func transfer_flag_to_zone(flag, zone):
	# Mover de lista a zona (lógica similar a la que tenías, pero invocada aquí)
	flag.get_parent().remove_child(flag)
	zone.add_child(flag)
	
	flag.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	flag.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED # Mantiene la proporción sin deformar
		
	if zone.size.x >= zone.size.y:
		flag.size.y = zone.size.y
		flag.custom_minimum_size.y = zone.size.y
	else:
		flag.size.x = zone.size.x
		flag.custom_minimum_size.x = zone.size.x

	flag.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	
	# Desactivar interacción de la bandera colocada
	flag.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flag.deselect_visuals() # Quitar el borde de selección
