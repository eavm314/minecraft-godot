extends CharacterBody3D
 
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const  sensitivity = 0.005
const RAY_LENGTH = 1000.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera: Camera3D = $Camera3D
 
# rayo
signal  des
var origin 
var end

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/4, PI/4)
 
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
 
	# Obtener la dirección hacia adelante
	var direction = -transform.basis.z

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# rayo
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	origin = camera.project_ray_origin(mousepos)
	end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# destroy
	if Input.is_action_just_pressed("destroy") and is_on_floor():
		block_collision(result)
	
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
 
	move_and_slide()

func block_collision(result):
	if result.size() != 0:
		var position = result.position
		print(result.position)
		emit_signal("des", position)
		"""var bloque = load("res://scenes/Bloque.tscn")
		var instancia_bloque = bloque.get_instance_id()
		var nodo_bloque = instancia_bloque.get_node(".")
		nodo_bloque.destroy()"""
