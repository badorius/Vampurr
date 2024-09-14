extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const PointsIndicator = preload("res://Hud/points_indicator.tscn")
@onready var hud : CanvasLayer = get_node("../Hud")

#Var state_machine animation
var state_machine

@export var StartPosition = global_position

#Shot blood scene loaded to instanciate on shot
const ShotBlood = preload("../ShotBlood/shot_blood.tscn")
var ShotBloodDirection = 1

#Load HUD in order to modify lives and scores
@onready var HUD : CanvasLayer = get_node("../Hud")

#Sounds
@onready var JumpSound = $VampurrJump

func _ready() -> void:
		state_machine = $AnimationTree.get('parameters/playback')
		state_machine.travel('Iddle')


func _physics_process(delta):
	
	# Exit
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		state_machine.travel('Jump')
		JumpSound.play()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		
		#Set shoting direction
		ShotBloodDirection = direction
		#Flip sprite direction
		if direction == -1:
			get_node( "Vampurv1Ingrid" ).set_flip_h( true )
		if direction == 1:
			get_node( "Vampurv1Ingrid" ).set_flip_h( false )
		
		#If direction move player
		velocity.x = direction * SPEED

		#After flip and movve, if are shoting run animation Shot instead run
		if Input.is_action_just_pressed("ui_shot"):
			state_machine.travel('Shot')
			shoting(ShotBloodDirection)

		#Is not shoting set animation between Run or jump:
		else:
			if is_on_floor():
				state_machine.travel('Run')
			else:
				state_machine.travel('Jump')
				
	#There's no direction, so are iddle, shoting or jumping:
	else:
		#No direction but shoting:
		if Input.is_action_just_pressed("ui_shot"):
			shoting(ShotBloodDirection)
		#No direction and no shoting:
		else:
			#No direction and no shoting and no jumping, so iddle:
			if is_on_floor():
				state_machine.travel('Iddle')
				velocity.x = move_toward(velocity.x, 0, SPEED)
			#No direction, no shoting but jumping:
			else:
				state_machine.travel('Jump')

	#Move Player on screen
	move_and_slide()
	
	
#FUNC shoting blood
func shoting(ShotBlood_direction):
	state_machine.travel('Shot')
	var main = get_tree().current_scene
	var A = ShotBlood.instantiate()
	A.global_position = global_position
	if ShotBlood_direction == 1:
		A.position.x = global_position.x + 14
	if ShotBlood_direction == -1:
		A.position.x = global_position.x - 14
	A.direction = ShotBlood_direction
	main.add_child(A)
	
func die():
	state_machine.travel('Die')
	global_position = StartPosition
	GameManager.lives -= 1
	HUD.update_hud()
	if GameManager.lives <= 0:
		gameover()
		
func gameover():
		get_tree().quit()
		
func showpoints(VALUE):
	var offset_position = randi() % 20
	var main = get_tree().current_scene
	var points = PointsIndicator.instantiate()
	var color = "white"
	points.global_position = Vector2(global_position.x - offset_position, (global_position.y) - offset_position)
	points.show_points(VALUE, color)
	main.add_child(points)
	
	GameManager.score += VALUE
	hud.update_hud() 
	
		
#SIGNALS START HERE
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies") and not body.is_bubbled and not body.is_dead:
		die()
				
