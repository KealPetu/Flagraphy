extends Control

@onready var boton_regresar: Button = $BotonRegresar
@onready var boton_norteamerica: Button = $ContenedorBotones/ContenedorBotonesAmericas/BotonNorteamerica
@onready var boton_sudamerica: Button = $ContenedorBotones/ContenedorBotonesAmericas/BotonSudamerica

const MENU_PRINCIPAL = "res://Scenes/MenuPrincipal.tscn"
const NORTEAMERICA = "res://Scenes/Levels/Norteamerica.tscn"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boton_regresar.pressed.connect(cambiar_escena_menu_principal)
	boton_norteamerica.pressed.connect(cambiar_escena_nivel)
	pass

func cambiar_escena_menu_principal():
	get_tree().change_scene_to_file(MENU_PRINCIPAL)

func cambiar_escena_nivel():
	get_tree().change_scene_to_file(NORTEAMERICA)
	pass
