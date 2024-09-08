extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0
@export var direction : int = 1
@export var ReadyToExplode : int = 0


var state_machine

@onready var bubble_sound_pop = $BubblePop
@onready var bubble_sound_explode = $BubbleExplode


func _ready() -> void:
		state_machine = $AnimationTree.get('parameters/playback')
		state_machine.travel('Run')
		
		#Set flip sprite direction
		if direction == 1:
			get_node( "ShotBloodSprite" ).set_flip_h( false )
		if direction == -1:
			get_node( "ShotBloodSprite" ).set_flip_h( true )
		
		bubble_sound_pop.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
			
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		velocity.x = direction * SPEED

	move_and_slide()
	
func explode():
	#state_machine.travel('Explode')
	pass
	
#SIGNALS START HERE
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.is_bubbled = true
	else:
		ReadyToExplode += 1
		if ReadyToExplode >= 3:
			explode()
			
