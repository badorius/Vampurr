extends Node2D

#Var to public view viewport size rectangle from camera
@export var rect : Vector2

#Var enemies to instantiate on level:
@export var num_pug = 1
@export var pug_scene: PackedScene = preload("res://Enemies/Pug/pug.tscn")
@export var level_finished : bool = false
@export var stage : int = 1
@onready var player : CharacterBody2D = get_node("PlayerDemo/")
@onready var hud : CanvasLayer = get_node("Hud/")



# Var to get spawn_timer
@onready var spawn_timer = $Timer
@onready var timer_demo = $TimerDemo

# Var to count how many enemies has been spawned:
var pug_spawned = 0


# Called when the node enters the scene tree for the first time.

func _ready():

	$Player.visible = false
	
	randomize() # Neede to  get random spawn each time
	spawn_timer.connect("timeout", Callable(self, "_on_SpawnTimer_timeout"))
	schedule_next_spawn() # Call function
	#Assign viewport rect value / 2.0 in order to work between 1 vs -1 
	rect = get_viewport_rect().size / 2.0	
	
func _on_SpawnTimer_timeout():
	if pug_spawned < num_pug:
		spawn_pug()
		pug_spawned += 1
		schedule_next_spawn()
	else:
		spawn_timer.stop()

func schedule_next_spawn():
	var random_interval = randi_range(1, 5)  # Schedule next between 1, 3 seconds
	spawn_timer.wait_time = random_interval
	spawn_timer.start()

func spawn_pug():
	var pug_instance = pug_scene.instantiate()
	pug_instance.position = get_random_position()
	add_child(pug_instance)
	#Pass rect value to pug in order to get movement inteligence depending of sice window
	pug_instance.rect = rect
	print("Pug instanciado en posición: ", pug_instance.position)

func get_random_position() -> Vector2:
	#Randomize x position from rect value
	var random_x = randf_range(rect.x * -1, rect.x)
	#Uncoment this line if you want to randomize y
	#var random_y = randf_range(rect.y * -1, rect.y)
	#Fix y position:
	var random_y = -70

	
	return Vector2(random_x, random_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if Input.is_action_just_pressed("insertcoin"):
		GameManager.credits += 1
		hud.update_hud()
	if Input.is_action_just_pressed("push1player"):
		GameManager.credits -= 1
		hud.update_hud()
		endlevel()
		
	match stage:
		1:
			disable_instructions()
			$Instructions1.visible = true
			player.walkright()
		2:
			disable_instructions()
			$Instructions1.visible = true
			player.walkleft()
			
		3:
			disable_instructions()
			$Instructions1.visible = true
			player.walkright()
			
		4:
			disable_instructions()
			$Instructions2.visible = true
			player.jump()
			
		5:
			disable_instructions()
			$Instructions3.visible = true
			player.shot()
			
			
	if level_finished == true:
		get_tree().quit()

func disable_instructions():
	$Instructions1.visible = false
	$Instructions2.visible = false
	$Instructions3.visible = false
	
	
func endlevel():
	var FILE_BEGIN = "res://Levels/Level"
	var current_scene_file = get_tree().current_scene.scene_file_path
	print(current_scene_file)
	###FIX TO PENDING - 10 
	var next_level_number = current_scene_file.to_int() + 1 - 10
	print(current_scene_file.to_int())
	var next_level_path = FILE_BEGIN + str(next_level_number) + "/level"+ str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
	#get_tree().quit()

func _on_timer_demo_timeout() -> void:
	if stage < 5:
		stage += 1
	else:
		stage = 0
