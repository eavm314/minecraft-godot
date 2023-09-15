extends RigidBody3D

@export var resistencia: int
@export var tipo: String
@export var vida: int 

func destroy ():
	vida -= resistencia
	if vida <= 0:
		print("aaaa moriiiii")
		queue_free()
