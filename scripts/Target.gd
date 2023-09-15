extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	# Obtener el rectángulo del viewport
	var window = get_viewport_rect()
	# Calcular el punto medio
	var punto_medio = Vector2(window.size.x / 2, window.size.y / 2)
	position = punto_medio - Vector2(size.x / 2, size.y / 2)
