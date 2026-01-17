class_name LevelBase extends Node2D # class_name permite que otros scripts sepan qué es esto

@export var level_name: String = "Nivel Genérico"
@onready var flag_container = $HSplitContainer/ScrollContainer/FlagContainer # Ajusta la ruta
@onready var map_container = $HSplitContainer/MapContainer # Ajusta la ruta
@onready var puntaje_label = $TopPanel/HBoxContainer/Puntaje # Ajusta la ruta a tu nodo
@onready var nivel: Label = $TopPanel/HBoxContainer/Nivel

# Referencia a la escena de la bandera para instanciarla dinámicamente
var flag_scene = preload("res://Scenes/Flag.tscn") 

var score = 0
var total_countries = 0
var score_per_country = 10

func _ready():
	setup_level()

func setup_level():
	# 1. Buscar todas las "CountryZones" que existen en el mapa
	var countries = map_container.get_children()
	
	for node in countries:
		if node.has_method("_drop_data"): # Verificamos si es una zona de país válida
			create_flag_for_country(node.target_country)
			total_countries += 1
	# Reordenar las banderas aleatoriamente para que no estén en orden
	randomize_flags()

func create_flag_for_country(country_name: String):
	var new_flag = flag_scene.instantiate()
	new_flag.country_name = country_name
	
	# Intentamos cargar la textura dinámicamente si el nombre del archivo coincide
	# Ejemplo: "Canada" busca "res://Assets/Banderas/Norte America/Canada.svg"
	var path = "res://Assets/Banderas/" + nivel.text + '/' + country_name + ".svg"
	if ResourceLoader.exists(path):
		new_flag.texture = load(path)	
	else:
		printerr("No se encontró imagen para: " + country_name)
	
	# Texto alternativo para accesibilidad
	new_flag.alt_text_description = "Bandera de " + country_name
	
	flag_container.add_child(new_flag)

func randomize_flags():
	# Obtener hijos y reordenarlos en el contenedor
	var flags = flag_container.get_children()
	flags.shuffle()
	for flag in flags:
		flag_container.move_child(flag, flag.get_index())

func speak_feedback(text):
	DisplayServer.tts_speak(text, "")

# Función para conectar desde la interfaz a cada zona
func _on_country_zone_flag_dropped_correctly():
	score += 10
	puntaje_label.text = "Puntaje: " + str(score)
	check_win_condition()

func _on_reset_button_pressed():
	get_tree().reload_current_scene() # Reinicia el nivel

func check_win_condition():
	if score == total_countries * score_per_country: # 3 países x 10 puntos
		print("¡Nivel Completado!")
		# Aquí podrías mostrar un popup de victoria
