extends CharacterBody2D


const SPEED = 30.0
const JUMP_VELOCITY = -350.0

 

#Start random direction 
@onready var random = RandomNumberGenerator.new()

@export var direction = 0
@export var jump = 0
@export var rect : Vector2


func _ready() -> void:
	RandomNumberGenerator.new()
	random_direction()
	random_jump()
	
func random_direction():
	var randomnumber = random.randi_range(-1, 1)
	if randomnumber == 0:
		random_direction()
	else:
		direction = randomnumber
		
		
func random_jump():
	jump = random.randi_range(1, 10)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# If Pug is on bottom, jump! needs to improve.
	if jump == 1 and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#if position.y >= 88 and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	"""
	if global_position.x >= rect.x - 23:
		direction = direction * -1
		print(global_position.x)
		
	if global_position.x <= (rect.x - 23) * -1:
		direction = direction * -1
		print(global_position.x)
	"""
		#Uncoment to stop
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		
	velocity.x = direction * SPEED
	
	#Regenerate random jump
	jump = random.randi_range(1, 20)
	move_and_slide()
	

#SIGNALS START HERE
func _on_area_2d_body_entered(body: Node2D) -> void:
	direction = direction * -1
