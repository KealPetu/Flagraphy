class_name LevelBase extends Control # class_name permite que otros scripts sepan qué es esto

@export var level_name: String = "Nivel Genérico"
@onready var flag_container = $HSplitContainer/ScrollContainer/FlagContainer
@onready var map_container = $HSplitContainer/MapContainer
@onready var puntaje_label = $TopPanel/HBoxContainer/Puntaje
@onready var nivel_label: Label = $TopPanel/HBoxContainer/Nivel
@onready var boton_regresar: Button = $TopPanel/HBoxContainer/BotonRegresar

# Referencia a la escena de la bandera para instanciarla dinámicamente
var flag_scene = preload("res://Scenes/Objects/Flag.tscn")
const MENU_SELECCION = "res://Scenes/MenuSeleccion.tscn"

const POINTS_PER_COUNTRY = 10
var score = 0
var max_score = 0
var total_countries = 0
var spanish_voice_id = ""

func _ready():
	nivel_label.text = level_name
	_find_spanish_voice()
	setup_level()
	max_score = POINTS_PER_COUNTRY * total_countries
	puntaje_label.text = str(score) + "/" + str(max_score)
	boton_regresar.pressed.connect(cambiar_escena_menu_seleccion)

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
	# 1. Buscar todas las "CountryZones" que existen en el mapa
	var countries = map_container.get_children()
	
	for node in countries:
		if node.has_method("_drop_data"): # Verificamos si es una zona de país válida
			create_flag_for_country(node.target_country)
			total_countries += 1

func create_flag_for_country(country_name: String):
	var new_flag = flag_scene.instantiate()
	new_flag.country_name = country_name
	new_flag.assigned_voice_id = spanish_voice_id
	
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

# Función para conectar desde la interfaz a cada zona
func _on_country_zone_flag_dropped_correctly():
	score += 10
	puntaje_label.text = str(score) + "/" + str(max_score)
	check_win_condition()

func _on_reset_button_pressed():
	get_tree().reload_current_scene() # Reinicia el nivel

func _on_boton_regresar_mouse_entered() -> void:
	speak_feedback("Botón de regresar")

func _on_boton_reinicio_mouse_entered() -> void:
	speak_feedback("Botón de reinicio")

func _on_mapa_textura_mouse_entered() -> void:
	speak_feedback(map_container.accessibility_name)

func cambiar_escena_menu_seleccion():
	get_tree().change_scene_to_file(MENU_SELECCION)
	pass
