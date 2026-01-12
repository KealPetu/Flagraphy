extends Control

var score = 0
@onready var score_label = $TopBar/HBoxContainer/ScoreLabel # Ajusta la ruta a tu nodo

func _ready():
	# Conectar las señales de las zonas de caída
	# Nota: Esto busca todos los nodos en el grupo "drop_zones" si los usas, 
	# o puedes conectarlos manualmente en la interfaz de Godot.
	pass

# Función para conectar desde la interfaz a cada zona
func _on_country_zone_flag_dropped_correctly():
	score += 10
	score_label.text = "Puntaje: " + str(score)
	check_win_condition()

func _on_reset_button_pressed():
	get_tree().reload_current_scene() # Reinicia el nivel

func check_win_condition():
	if score == 30: # 3 países x 10 puntos
		print("¡Nivel Completado!")
		# Aquí podrías mostrar un popup de victoria
