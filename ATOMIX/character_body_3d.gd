extends CharacterBody3D

const SPEED = 52.0
const JUMP_VELOCITY = 15.0
const GRAVITY = 9.81

@onready var neck := $neck
@onready var camera := $neck/Camera3D
@onready var model := $neck/model/RootNode
@onready var hand := $Hand
@onready var ray := $neck/Camera3D/RayCast3D

var held_item: Node = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event): 
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.001)
			camera.rotate_x(event.relative.y * 0.001)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
			model.rotation.y = camera.rotation.y

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("move_forwards"):
		input_dir.z += 1
	if Input.is_action_pressed("move_backwards"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_left"):
		input_dir.x += 1

	input_dir = input_dir.normalized()
	var direction = (neck.transform.basis * input_dir).normalized()

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	move_and_slide()
