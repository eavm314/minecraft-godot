extends Camera3D

var sensitivity = 0.2  # Ajusta la sensibilidad del mouse
var speed = 5.0  # Ajusta la velocidad de movimiento
var rotation_speed = 0.1  # Ajusta la velocidad de rotación

var rot_x = 0  # Rotación vertical de la cámara
var rot_y = 0  # Rotación horizontal de la cámara

func _input(event):
	if event is InputEventMouseMotion:
		rot_x -= event.relative.y * sensitivity
		rot_y -= event.relative.x * sensitivity
		rot_x = clamp(rot_x, -90, 90)  # Limita la rotación vertical

func _process(delta):
	# Aplicar rotación a la cámara
	rotation_degrees.x = rot_x
	rotation_degrees.y = rot_y

	# Obtener la dirección hacia adelante
	var direction = -transform.basis.z
