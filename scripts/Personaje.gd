extends CharacterBody3D
 
const SPEED = 3.0
const JUMP_VELOCITY = 4.5
const sensitivity = 0.005
const RAY_LENGTH = 5.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mapa: GridMap

@onready var camera: Camera3D = $Camera3D
@onready var tierra = preload("res://scenes/bloque_tierra.tscn")
@onready var rock = preload("res://scenes/bloque_rock.tscn")
@onready var hoja = preload("res://scenes/hojas_arbol.tscn")
@onready var vaca = preload("res://scenes/vaca.tscn")

@onready var audio_colocar = $ColocarBloque
@onready var audio_minar = $Minar


# rayo
var origin 
var end

var bloque_seleccionado;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mapa = get_parent().get_node("Mapa")
	bloque_seleccionado = tierra

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
 
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
 
	# Obtener la dirección hacia adelante
	var direction = -transform.basis.z

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# destroy
	if Input.is_action_just_pressed("destroy"):
		var space_state = get_world_3d().direct_space_state	
		var query = create_ray()
		var result = space_state.intersect_ray(query)
		block_collision(result)
		
	if Input.is_action_just_pressed("build"):
		var space_state = get_world_3d().direct_space_state	
		var query = create_ray()
		var result = space_state.intersect_ray(query)
		build_block(result)
	
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func create_ray():
	# rayo
	var mousepos = get_viewport().get_mouse_position()

	origin = camera.project_ray_origin(mousepos)
	end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
#	print(query)
#	query.collide_with_areas = true
	return query

func block_collision(result):
	if result.size() != 0:
		audio_minar.play()		
		var position = result.position
		result["collider"].destroy()
		
func build_block(result):
	if result.size() != 0:	
		audio_colocar.play()
		var pos = round(result["collider"].position)
		var normal = result["normal"]
#		print(pos)
#		print(result["collider"].position)
		# Instancia la escena en la posición de la celda
		var instance = bloque_seleccionado.instantiate()
		instance.global_transform.origin = pos + normal
		mapa.add_child(instance)
	
func _input(event):
	if event.is_action_released("tierra"):
		bloque_seleccionado = tierra
	if event.is_action_released("rock"):
		bloque_seleccionado = rock
	if event.is_action_released("hoja"):
		bloque_seleccionado = hoja
	if event.is_action_released("vaca"):
		bloque_seleccionado = vaca
