extends RigidBody3D

@export var resistencia: int
@export var tipo: String
@export var vida: int 

func destroy ():
	if vida >= 0:
		print("aaa muero")
		vida -= resistencia
	else :
		print("aaaa moriiiii")
		queue_free()
