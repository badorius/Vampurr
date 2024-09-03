extends CharacterBody2D


const SPEED = 30.0
const JUMP_VELOCITY = -300.0

var state_machine

#Start random direction 
@onready var random = RandomNumberGenerator.new()

@export var direction = 0
@export var jump = 0
@export var rect : Vector2
@export var is_bubbled : bool = false



func _ready() -> void:
	
	state_machine = $AnimationTree.get('parameters/playback')
	state_machine.travel('Run')
	
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
	flip_direction()
	# Add the gravity.
	if not is_on_floor() and not is_bubbled:
		velocity += get_gravity() * delta
		state_machine.travel('Jump')



	# Wehn jump random is 1 pug jump.
	if jump == 1 and is_on_floor() and not is_bubbled:
		velocity.y = JUMP_VELOCITY 
		state_machine.travel('Jump')
	else:
		if jump != 1 and  is_on_floor() and not is_bubbled:
			state_machine.travel('Run')


	velocity.x = direction * SPEED
	
	#Regenerate random jump
	jump = random.randi_range(1, 20)
	move_and_slide()
	
func flip_direction():
	#Flip sprite direction
	if direction == 1:
		get_node( "Vampurv1Ingrid" ).set_flip_h( true )
	if direction == -1:
		get_node( "Vampurv1Ingrid" ).set_flip_h( false )
		

func Bubble():
	is_bubbled = true
	state_machine.travel('Bubble')

#SIGNALS START HERE
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Weapon"):
		Bubble()
	else:
		direction = direction * -1
