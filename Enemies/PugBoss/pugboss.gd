extends CharacterBody2D


const SPEED = 30.0
const JUMP_VELOCITY = -300.0
const POINTS : int = 10000
var live : int = 5
@onready var HitSound = $Hit

const Coffin = preload("res://Items/Coffin/Coffin.tscn")

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
	#state_machine.travel('Jump')
		
func random_jump():
	jump = random.randi_range(1, 50)


func _physics_process(delta: float) -> void:
	
	# Si el jugador ha alcanzado el límite superior de la pantalla, bajar posicion player
	if global_position.y >= screen_size.y / 2:
		global_position.y = (screen_size.y / 2) * - 1

	# Si el jugador ha alcanzado el límite inferior de la pantalla, subir posicion player
	if global_position.y <  (screen_size.y / 2) * - 1:
		global_position.y = (screen_size.y / 2)
	
	if not is_dead:
		
		if live <= 0:
			Bubble()
			
		random_jump()

		if is_on_edge():
			direction = direction * -1
			
		flip_direction()
		if not is_on_floor() and not is_bubbled:
			velocity += get_gravity() * delta
			#state_machine.travel('Jump')

		# Wehn jump random is 1 pug jump.
		if jump == 1 and is_on_floor() and not is_bubbled:
			velocity.y = JUMP_VELOCITY
			#state_machine.travel('Jump')
		else:
			if jump != 1 and  is_on_floor() and not is_bubbled:
				state_machine.travel('Run')
				pass


	velocity.x = direction * SPEED
	
	#Regenerate random jump
	jump = random.randi_range(1, 20)
	move_and_slide()
	
func flip_direction():
	#Flip sprite direction
	if direction == 1:
		get_node( "PugBoss" ).set_flip_h( false )
	if direction == -1:
		get_node( "PugBoss" ).set_flip_h( true )
		

func Bubble():
	is_bubbled = true
	#state_machine.travel('Bubble')
	velocity.y = -1 * SPEED
	timer.start()
	
func die():
	is_bubbled = false
	is_dead = true
	direction = 0
	velocity.x = 0
	velocity.y = -1 * SPEED
	#state_machine.travel('Die')
	
	#FIX Random size
	var offset_position = randi() % 20
	var main = get_tree().current_scene
	var item = Coffin.instantiate()
	var color = "white"
	item.global_position = Vector2(global_position.x - offset_position, (global_position.y) - offset_position)
	get_tree().current_scene.call_deferred("add_child", item)
	#main.add_child(item)
	queue_free()

	#Needs animation die and points for playerz


func is_on_edge():
	if abs(global_position.x) > abs(screen_size.x/2 - 48):
		return true
	else:
		return false

func hit():
	live -= 1
	state_machine.travel('Hit')
	HitSound.play()

	
#SIGNALS START HERE #PENDING FIX 
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_dead:
		if body.is_in_group("Weapon") and not is_bubbled:
			hit()
			HitSound.play()
		if body.is_in_group("Player") and is_bubbled:
			body.showpoints(POINTS)
			die()
		if body.is_in_group("Enemies") and not is_bubbled:
			direction = direction * -1
			



func _on_timer_timeout() -> void:
	is_bubbled = false
	timer.stop() 
