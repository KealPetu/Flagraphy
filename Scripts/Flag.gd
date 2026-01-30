extends TextureRect

@export var country_name: String = "" 
var level_manager = null

func _ready():
	# Aseguramos que se pueda enfocar con teclado
	focus_mode = Control.FOCUS_ALL
	
	# Conectamos señales de foco para feedback visual
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)

func _gui_input(event):
	# ACEPTAR (Enter/Espacio) O CLIC IZQUIERDO
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		if level_manager:
			level_manager.on_flag_clicked(self)
			accept_event() # ¡Importante! Evita que el input se propague y cause doble acción

# --- FEEDBACK VISUAL (Ratón y Teclado) ---

# Cuando el teclado (Tab) o el ratón se posan sobre la bandera
func _on_focus_entered():
	# Hacemos que brille un poco o crezca
	modulate = Color(1.2, 1.2, 1.2) 
	# Opcional: scale = Vector2(1.1, 1.1)

func _on_focus_exited():
	# Verificamos si NO está seleccionada por el juego antes de quitar el brillo
	if level_manager.selected_flag != self:
		modulate = Color(1, 1, 1)
		# Opcional: scale = Vector2(1.0, 1.0)

# Estas son las funciones que llama el LevelBase (Lógica de juego)
func select_visuals():
	modulate = Color(0.5, 1.5, 0.5) # Verde brillante para indicar "ESTOY SELECCIONADO"
	
func deselect_visuals():
	modulate = Color(1, 1, 1) # Volver a la normalidad
