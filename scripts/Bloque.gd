extends RigidBody3D

@export var resistencia: int
@export var tipo: String
@export var vida: int 

func destroy ():
	print("aaa muero")
	"""if vida > 0:
		vida -= recistencia
	else :
		queue_free()"""
