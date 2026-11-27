extends CharacterBody3D

const SPEED = 55.0
const JUMP_VELOCITY = 10.5
const GRAVITY = 9.8
const MOUSE_SENS = 0.003

@onready var camera = $Head/Camera3D
@onready var pivot = $Head/Camera3D/RayCast3D

var mouse_x = 0.0
var mouse_y = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENS)
		pivot.rotate_x(-event.relative.y * MOUSE_SENS)
		pivot.rotation_degrees.x = clamp(pivot.rotation_degrees.x, -80, 80)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("move_forwards"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_backwards"):
		input_dir.z += 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1

	input_dir = input_dir.normalized()
	
	var direction = (global_transform.basis * input_dir).normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()
