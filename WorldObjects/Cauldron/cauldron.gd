extends CharacterBody2D

const SPEED = 30.0
const POINTS : int = 1000
var live : int = 50


# Var to count how many enemies has been spawned:
var pug_spawned = 0
@export var pug_scene: PackedScene = preload("res://Enemies/Pug/pug.tscn")
# Var to get spawn_timer
@onready var spawn_timer = $Timer

#Var state_machine animation
var state_machine
@export var is_dead : bool = false
@export var green_bubble: PackedScene = preload("res://WorldObjects/GreenBubbles/GreenBubbles.tscn")

#Needed to call crucifix inverted when cauldron dies or complete 
@onready var Crucifix1_floor1 : CharacterBody2D = get_node("../Crucifix1_floor1")
@onready var Crucifix2_floor1 : CharacterBody2D = get_node("../Crucifix2_floor1")
@onready var Crucifix1_floor2 : CharacterBody2D = get_node("../Crucifix1_floor2")
@onready var Crucifix2_floor2 : CharacterBody2D = get_node("../Crucifix2_floor2")
@onready var Crucifix3_floor2 : CharacterBody2D = get_node("../Crucifix3_floor2")
@onready var Crucifix4_floor2 : CharacterBody2D = get_node("../Crucifix4_floor2")
@onready var Crucifix1_floor3 : CharacterBody2D = get_node("../Crucifix1_floor3")
@onready var Crucifix2_floor3 : CharacterBody2D = get_node("../Crucifix2_floor3")

@onready var player : CharacterBody2D = get_node("../Player")


@export var is_shed : bool = false
@export var is_near_player : bool = false

@onready var HitSound = $Hit



func _ready() -> void:
	randomize() # Neede to  get random spawn each time
	spawn_timer.connect("timeout", Callable(self, "_on_SpawnTimer_timeout"))
	schedule_next_spawn() # Call function
	state_machine = $AnimationTree.get('parameters/playback')
	state_machine.travel('ChupChup')
	is_shed = false
	
func _physics_process(delta: float) -> void:
	# Define la distancia máxima en la cual consideras que el jugador está "cerca" del cauldron.
	var proximity_distance = 25  # Ajusta este valor según lo necesario

	# Verifica si la distancia en el eje Y entre el jugador y el cauldron está dentro del rango permitido.
	if abs(global_position.y - player.global_position.y) <= proximity_distance:
		is_near_player = true
	else:
		is_near_player = false

	if live <= 0:
		shed()

	if is_shed:
		velocity.y = -1 * SPEED
		move_and_slide()



func _on_SpawnTimer_timeout():
	if not is_shed:
		spawn_pug()
		schedule_next_spawn()
	else:
		spawn_timer.stop()
		#.shed()
		
func schedule_next_spawn():
	var random_interval = randi_range(1, 5)  # Schedule next between 1, 3 seconds
	spawn_timer.wait_time = random_interval
	spawn_timer.start()

func spawn_pug():
	if is_near_player:
		var pug_instance = pug_scene.instantiate()
		add_child(pug_instance)
		#Pass rect value to pug in order to get movement inteligence depending of sice window
		pug_instance.global_position = global_position
		pug_spawned += 1
		bubble()


func explode():
	#Pending animation explode to open crucifyx dors
	is_dead = true
	state_machine.travel('Die')

func shed():
	is_shed = true
	state_machine.travel('Die')
	var floor = get_floor()  # Determina el piso en el que está el cauldron.
	print(floor)
	match floor:
		1:
			Crucifix1_floor1.inverted()
			Crucifix2_floor1.inverted()
		2:
			Crucifix1_floor2.inverted()
			Crucifix2_floor2.inverted()
			Crucifix3_floor2.inverted()
			Crucifix4_floor2.inverted()
			
		3:
			Crucifix1_floor3.inverted()
			Crucifix2_floor3.inverted()

func get_floor():
	# Calcula en qué piso se encuentra el cauldron.
	var floor_height = 244  # Altura de cada piso.
	return int(global_position.y / floor_height) + 1  # Devuelve el número de piso (asumiendo que empieza desde el piso 1).


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

		
