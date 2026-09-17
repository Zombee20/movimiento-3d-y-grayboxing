extends CharacterBody3D

var Speed = 2.0
var Jump = 3
var gravity = -10
var saltos = 0
var sensibility = 0.01
@onready var camera = $GiroCamara
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("Salto"):
		if saltos < 2:
			velocity.y = Jump
			saltos += 1
		elif is_on_floor():
			saltos = 0
	var input_dir := Input.get_vector("Derecha", "Izquierda", "Atras", "Adelante")
	var direction := transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	direction.y = 0
	
	if direction:
		velocity.x = direction.x * Speed
		velocity.z = direction.z * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		velocity.z = move_toward(velocity.z, 0, Speed)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensibility)
		camera.rotate_x(event.relative.y * sensibility)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80),deg_to_rad(80))
