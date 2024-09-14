extends CharacterBody2D


const SPEED = 30.0
const JUMP_VELOCITY = -300.0
const POINTS : int = 100

const randomitem = preload("res://Items/RandomItem/RandomItem.tscn")

var state_machine

#Sounds
@onready var popdie = $PopDie

#Start random direction 
@onready var random = RandomNumberGenerator.new()

@export var direction = 0
@export var jump = 0
@export var rect : Vector2
@export var is_bubbled : bool = false
@export var is_dead : bool = false




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
	
	if not is_dead:
		flip_direction()
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

		if is_bubbled:
			Bubble()

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
	velocity.y = -1 * SPEED
	
func debuganimation():
	print("Animation Entered")
	
	
func die():
	is_bubbled = false
	is_dead = true
	state_machine.travel('Die')
	direction = 0
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.y = 1 * SPEED
	
	#FIX Random size
	var offset_position = randi() % 20
	var main = get_tree().current_scene
	var item = randomitem.instantiate()
	var color = "white"
	item.global_position = Vector2(global_position.x - offset_position, (global_position.y) - offset_position)
	main.add_child(item)

	#Needs animation die and points for playerz
	state_machine.travel('Die')



	
#SIGNALS START HERE #PENDING FIX 
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_dead:
		if body.is_in_group("Weapon") and not is_bubbled:
			Bubble()
		if body.is_in_group("Player") and is_bubbled:
			body.showpoints(POINTS)
			die()
		else:
			direction = direction * -1
