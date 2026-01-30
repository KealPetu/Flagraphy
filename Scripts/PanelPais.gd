extends Panel

@export var target_country: String = ""
var level_manager = null 

# Guardamos el estilo original para restaurarlo después
var original_style: StyleBox

func _ready():
	focus_mode = Control.FOCUS_ALL
	
	# Guardamos el estilo actual (que probablemente es invisible/empty)
	original_style = get_theme_stylebox("panel")
	
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)

func _gui_input(event):
	# ACEPTAR (Enter/Espacio) O CLIC IZQUIERDO
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		if get_child_count() > 0: return # Ya ocupado
		
		if level_manager:
			level_manager.on_zone_clicked(self)
			accept_event()

# --- FEEDBACK VISUAL CRÍTICO ---
func _on_focus_entered():
	# Cuando el teclado pasa por aquí, necesitamos ver dónde estamos.
	# Opción A: Crear un borde temporal por código
	var new_style = StyleBoxFlat.new()
	new_style.bg_color = Color(0, 0, 0, 0.2) # Fondo semitransparente negro
	new_style.border_width_left = 2
	new_style.border_width_top = 2
	new_style.border_width_right = 2
	new_style.border_width_bottom = 2
	new_style.border_color = Color(1, 1, 0) # Borde Amarillo
	
	add_theme_stylebox_override("panel", new_style)

func _on_focus_exited():
	# Quitar el estilo temporal
	remove_theme_stylebox_override("panel")
