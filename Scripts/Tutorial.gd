class_name Tutorial extends Control

@onready var boton_regresar: Button = $BotonRegresar

var escena_menu_principal = "res://Scenes/MenuPrincipal.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boton_regresar.pressed.connect(cambiar_escena_menu_principal)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func cambiar_escena_menu_principal():
	get_tree().change_scene_to_file(escena_menu_principal)
