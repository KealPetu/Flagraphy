extends Control

@onready var nombre_line_edit: LineEdit = $Opciones/NombreLineEdit
@onready var boton_jugar: Button = $Opciones/BotonJugar
@onready var boton_configuraciones: Button = $Opciones/BotonConfiguraciones
@onready var boton_como_jugar: Button = $Opciones/BotonComoJugar

var escena_tutorial = "res://Scenes/Tutorial.tscn"
var escena_configuraciones = "res://Scenes/Configuraciones.tscn"
var escena_seleccion_nivel_pais = "res://Scenes/MenuSeleccion.tscn"

func _ready() -> void:
	boton_como_jugar.pressed.connect(cambiar_escena_tutorial)
	boton_configuraciones.pressed.connect(cambiar_escena_configuraciones)
	boton_jugar.pressed.connect(cambiar_escena_juego)

func cambiar_escena_tutorial():
	get_tree().change_scene_to_file(escena_tutorial)

func cambiar_escena_configuraciones():
	get_tree().change_scene_to_file(escena_configuraciones)

func cambiar_escena_juego():
	get_tree().change_scene_to_file(escena_seleccion_nivel_pais)
