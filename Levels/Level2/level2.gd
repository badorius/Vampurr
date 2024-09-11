extends Node2D

#Var to public view viewport size rectangle from camera
@export var rect : Vector2

#Var enemies to instantiate on level:
@export var num_pug = 5
@export var pug_scene: PackedScene = preload("res://Enemies/Pug/pug.tscn")
@export var level_finished : bool = false


# Var to get spawn_timer
@onready var spawn_timer = $Timer

# Var to count how many enemies has been spawned:
var pug_spawned = 0

#MUSIC VAR
@onready var BgMusic = $BGMusicLVL1

# Called when the node enters the scene tree for the first time.

func _ready():
	randomize() # Neede to  get random spawn each time
	spawn_timer.connect("timeout", Callable(self, "_on_SpawnTimer_timeout"))
	schedule_next_spawn() # Call function
	#Assign viewport rect value / 2.0 in order to work between 1 vs -1 
	rect = get_viewport_rect().size / 2.0
	BgMusic.play()
	
	
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
	#Uncoment tzzis line if you want to randomize y
	#var random_y = randf_range(rect.y * -1, rect.y)
	#Fix y position:
	var random_y = -70

	
	return Vector2(random_x, random_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if level_finished == true:
		get_tree().quit()

		
