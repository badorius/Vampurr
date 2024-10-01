extends CharacterBody2D

const SPEED = 30.0
const POINTS : int = 1000
var live : int = 50

#Var state_machine animation
var state_machine
@export var is_dead : bool = false
@export var green_bubble: PackedScene = preload("res://WorldObjects/GreenBubbles/GreenBubbles.tscn")

#Needed to call crucifix inverted when cauldron dies or complete 
@onready var Crucifix1 : CharacterBody2D = get_node("../Crucifix1")
@onready var Crucifix2 : CharacterBody2D = get_node("../Crucifix2")

@export var is_shed : bool = false
@onready var HitSound = $Hit



func _ready() -> void:
	randomize() # Neede to  get random spawn each time
	#Assign viewport rect value / 2.0 in order to work between 1 vs -1 
	state_machine = $AnimationTree.get('parameters/playback')
	#bubble()
	state_machine.travel('ChupChup')
	#$CollisionShape2D.disabled = true
	#$Area2D/CollisionShape2D.disabled = true
	is_shed = false
	
func _physics_process(delta: float) -> void:

	if live <= 0:
		shed()
		
	if is_shed:
		velocity.y = -1 * SPEED

		move_and_slide()




func explode():
	#Pending animation explode to open crucifyx dors
	is_dead = true
	state_machine.travel('Die')

func shed():
	is_shed = true
	state_machine.travel('Die')
	Crucifix1.inverted()
	Crucifix2.inverted()


func bubble():
	var green_bubble = green_bubble.instantiate()
	green_bubble.global_position = global_position
	green_bubble.global_position.y -= 10
	add_child(green_bubble)
	#Pass rect value to pug in order to get movement inteligence depending of sice window
	
func hit():
	live -= 1
	state_machine.travel('Hit')
	#HitSound.play()



func change_color():
	var random_colour = Color(randf(), randf(), randf())
	return random_colour
	
func die():
	is_shed = false
	is_dead = true
	velocity.y = -1 * SPEED
	state_machine.travel('Explode')

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Crucifix") and is_shed:
		body.showpoints(POINTS)
		die()
	if body.is_in_group("Weapon"):
		hit()
		HitSound.play()

		
