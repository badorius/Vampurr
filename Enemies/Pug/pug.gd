extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -300.0

#Start random direction 
@onready var rndx = randi() % 2
@onready var rndy = randi() % 2

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	print (rndx)
	print (rndy)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = rndx
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
