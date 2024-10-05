extends CharacterBody2D
var maxup = 10
var maxdown = 10
const POINTS : int = 500
const SPEED = 30.0
const JUMP_VELOCITY = -50.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#PARABOLA MOVEMENT VARS
var screen_size  # Tamaño de la pantalla
var direction_x = 1  # 1 = derecha, -1 = izquierda
var direction_y = 1  # 1 = derecha, -1 = izquierda
var speed_x = 50  # Velocidad en el eje X
var speed_y = 75  # Velocidad inicial en el eje Y
@onready var start_y : float = global_position.y

#Vars to Wave y movement
var bob_height : int = 60
var bob_speed : int = 4
var bob_count : int = 0
var t : float = 0.0

@onready var sound = $Pickup


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
	# Obtener el tamaño de la pantalla
	screen_size = get_viewport().get_visible_rect().size
	# Determinar si el item está en la mitad izquierda o derecha de la pantalla
	if global_position.x > screen_size.x / 2:
		direction_x = -1  # Mover hacia la izquierda si está en la mitad derecha
	else:
		direction_x = 1  # Mover hacia la derecha si está en la mitad izquierda
		
	# Determinar si el item está en la mitad arriba o abajo de la pantalla
	if global_position.y > screen_size.y / 2:
		direction_y = -1  # Mover hacia la arriba si está en la mitad abajo
	else:
		direction_y = 1  # Mover hacia la derecha si está en la mitad arriba

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bob_count <= 1:
		#velocity += get_gravity() * delta
		# Movimiento horizontal controlado por la dirección y velocidad en X
		global_position.x += direction_x * speed_x * delta
		global_position.x = clamp(global_position.x, 0, screen_size.x)
		
		# increase 't' over time.
		t += delta
		# creloopate a sin wave that bobs up and down.
		var d = (sin(t * bob_speed) + 1) / 2
		# apply that to  Y position.
		global_position.y = start_y - (d * bob_height) * direction_y

		if (int(global_position.y - start_y)) == 0:
			bob_count += 1
	else:
		velocity += get_gravity() * delta

		if abs(global_position.y) < abs(screen_size.y / 2):
			$Area2D/CollisionShape2D.disabled = false
			$CollisionShape2D.disabled = false

	move_and_slide()

	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.showpoints(POINTS)
		queue_free()
