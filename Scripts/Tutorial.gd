extends Control

@onready var boton_regresar: Button = $BotonRegresar

var escena_menu_principal = "res://Scenes/MenuPrincipal.tscn"

func _ready() -> void:
	boton_regresar.pressed.connect(cambiar_escena_menu_principal)

func cambiar_escena_menu_principal():
	get_tree().change_scene_to_file(escena_menu_principal)
