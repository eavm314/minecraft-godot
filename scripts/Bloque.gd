extends RigidBody3D

@export var resistencia: int
@export var tipo: String
@export var vida: int 

func destroy():
	if vida > 0:
		vida -= resistencia
	if vida <= 0:
		queue_free()  
