extends CharacterBody2D


const SPEED = 30.0
const JUMP_VELOCITY = -300.0
const POINTS : int = 100

const randomitem = preload("res://Items/RandomItem/RandomItem.tscn")
var state_machine

var screen_size  # Tamaño de la pantalla

#Sounds
@onready var popdie = $PopDie

#Start random direction 
@onready var random = RandomNumberGenerator.new()

@export var direction = -1
@export var jump = 0
@export var rect : Vector2
@export var is_bubbled : bool = false
@export var is_dead : bool = false

@onready var timer = $Timer



func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	$CollisionShape2D.disabled = false
	$Area2D/CollisionShape2D2.disabled = false
	state_machine = $AnimationTree.get('parameters/playback')
	state_machine.travel('Run')
	
	RandomNumberGenerator.new()
	random_jump()
	velocity.y = JUMP_VELOCITY 
	state_machine.travel('Jump')
		
func random_jump():
	jump = random.randi_range(1, 50)


func _physics_process(delta: float) -> void:
	
	if not is_dead:
		random_jump()

		if is_on_edge():
			direction = direction * -1
			
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
	timer.start()
	
func die():
	is_bubbled = false
	is_dead = true
	direction = 0
	velocity.x = 0
	velocity.y = -1 * SPEED
	state_machine.travel('Die')

	#FIX Random size
	var offset_position = randi() % 20
	var main = get_tree().current_scene
	var item = randomitem.instantiate()
	var color = "white"
	item.global_position = Vector2(global_position.x - 5, (global_position.y) - 5)

	main.add_child(item)

	#Needs animation die and points for playerz


func is_on_edge():
	if abs(global_position.x) > abs(screen_size.x/2 - 24):
		return true
	else:
		return false

	
#SIGNALS START HERE #PENDING FIX 
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_dead:
		if body.is_in_group("Weapon") and not is_bubbled:
			Bubble()
		if body.is_in_group("Player") and is_bubbled:
			body.showpoints(POINTS)
			die()
		if body.is_in_group("Enemies") and not is_bubbled:
			direction = direction * -1
			



func _on_timer_timeout() -> void:
	is_bubbled = false
	timer.stop() 
