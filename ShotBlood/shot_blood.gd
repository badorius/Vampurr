extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0
@export var direction : int = 1

var state_machine

@onready var bubble_sound = $BubblePop


func _ready() -> void:
		state_machine = $AnimationTree.get('parameters/playback')
		state_machine.travel('Run')
		
		#Set flip sprite direction
		if direction == 1:
			get_node( "ShotBloodSprite" ).set_flip_h( false )
		if direction == -1:
			get_node( "ShotBloodSprite" ).set_flip_h( true )
		
		bubble_sound.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		velocity.x = direction * SPEED

	move_and_slide()
	
#SIGNALS START HERE
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		print("Collide")
