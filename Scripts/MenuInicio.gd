extends Control

var escena_menu_principal = "res://Scenes/MenuPrincipal.tscn" 
@onready var boton_inicio: Button = $BotonInicio

func _ready() -> void:
	boton_inicio.pressed.connect(cambiar_escena_menu_principal)

func cambiar_escena_menu_principal():
	# Esta función cambia la escena actual por la nueva y borra la anterior de la memoria
	get_tree().change_scene_to_file(escena_menu_principal)
