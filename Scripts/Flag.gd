extends TextureRect

@export var country_name: String = "" 
var level_manager = null

func _gui_input(event):
	# Detectar clic izquierdo O acción de teclado ("ui_accept" es Enter/Espacio por defecto)
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or event.is_action_pressed("ui_accept"):
		if level_manager:
			level_manager.on_flag_clicked(self)
			accept_event() # Consumir el evento para evitar dobles inputs

func select_visuals():
	modulate = Color(1.2, 1.2, 1.2) 

func deselect_visuals():
	modulate = Color(1, 1, 1)
