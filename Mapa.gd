extends GridMap

# Escena que deseas instanciar en cada celda
@onready var cell_scene = preload("res://scenes/bloque_tierra.tscn")
@export var size: int
@export var profundidad: int

# Called when the node enters the scene tree for the first time.
func _ready():
	# Obtén el tamaño del GridMap en términos de celdas
	var grid = []
	
	for i in range(-size, size+1):
		for k in range(-size, size+1):
			for j in range(profundidad):
				grid.append(Vector3(i,j,k))
	# Recorre todas las celdas del GridMap
	for cell_pos in grid:
		print(cell_pos)
		# Instancia la escena en la posición de la celda
		var instance = cell_scene.instantiate()
		instance.global_transform.origin = cell_pos
		add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
