extends CharacterBody2D
var maxup = 10
var maxdown = 10
const POINTS : int = 500
const SPEED = 30.0
const JUMP_VELOCITY = -50.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#PARABOLA MOVEMENT VARS
var screen_size  # Tamaño de la pantalla
var direction = 1  # 1 = derecha, -1 = izquierda
var speed_x = 50  # Velocidad en el eje X
var speed_y = 50  # Velocidad inicial en el eje Y
#var gravity = 300  # Gravedad para simular el arco (ajustable)
var time_passed = 0.0  # Tiempo acumulado para controlar el movimiento
var parabola : bool = true

#Vars to Wave y movement
var bob_height : float = 3.0
var bob_speed : float = 8.0
var t : float = 0.0

@onready var sound = $Pickup


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D/CollisionShape2D.disabled = true
	# Obtener el tamaño de la pantalla
	screen_size = get_viewport().get_visible_rect().size
	# Determinar si el item está en la mitad izquierda o derecha de la pantalla
	if global_position.x > screen_size.x / 2:
		direction = -1  # Mover hacia la izquierda si está en la mitad derecha
	else:
		direction = 1  # Mover hacia la derecha si está en la mitad izquierda

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parabola:
		$Area2D/CollisionShape2D.disabled = true
	else:
		$Area2D/CollisionShape2D.disabled = false

	if not is_on_floor():
		#velocity += get_gravity() * delta
		# Movimiento horizontal controlado por la dirección y velocidad en X
		global_position.x += direction * speed_x * delta
		global_position.y += speed_y * delta + 0.5 * gravity * pow(time_passed, 2)
		global_position.x = clamp(global_position.x, 0, screen_size.x)
	else:
		parabola = false
	move_and_slide()

	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.showpoints(POINTS)
		queue_free()
