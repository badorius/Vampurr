extends Node2D

#Var to public view viewport size rectangle from camera
@export var rect : Vector2

#Var enemies to instantiate on level:
@export var level_finished : bool = false
@export var stage : int = 1
@onready var player : CharacterBody2D = get_node("PlayerDemo/")
@onready var hud : CanvasLayer = get_node("Hud/")
#Sounds
@onready var insertcoin = $InsertCoin

var state_machine

# Var to get spawn_timer
@onready var spawn_timer = $Timer
@onready var timer_demo = $TimerDemo

@export var high_scores : Array = [
	{"lvl": 43, "score": 50000, "name": "SSS"},
	{"lvl": 14, "score": 48700, "name": "NFH"},
	{"lvl": 15, "score": 32400, "name": "NJP"},
	{"lvl": 8,  "score": 21000, "name": "XYZ"},
	{"lvl": 5,  "score": 19000, "name": "ABC"}
]


func _ready():
	
	sort_high_scores()
	show_high_scores()
	state_machine = $AnimationTree.get('parameters/playback')
	state_machine.travel('InsertCoin')
	$Player.visible = false
	$InsertCoin2.visible = false
	$PushOnePlayer.visible = false
	$HighScore.visible = false
	
	randomize() # Neede to  get random spawn each time
	spawn_timer.connect("timeout", Callable(self, "_on_SpawnTimer_timeout"))
	schedule_next_spawn() # Call function
	#Assign viewport rect value / 2.0 in order to work between 1 vs -1 
	rect = get_viewport_rect().size / 2.0	
	

func schedule_next_spawn():
	var random_interval = randi_range(1, 5)  # Schedule next between 1, 3 seconds
	spawn_timer.wait_time = random_interval
	spawn_timer.start()


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
		$InsertCoin2.visible = false
		state_machine.travel('push1player')
		insertcoin.play()
		GameManager.credits += 1
		hud.update_hud()
	if Input.is_action_just_pressed("push1player"):
		if GameManager.credits > 0:
			GameManager.credits -= 1
			hud.update_hud()
			endlevel()
		
	match stage:
		1:
			DisableHighScore()
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
			
		6: 
			EnableHighScore()
			
	if level_finished == true:
		get_tree().quit()


func EnableHighScore():
	$HighScore.label_settings.font_color = change_color()

	$Layer0.visible = false
	$Instructions1.visible = false
	$Instructions2.visible = false
	$Instructions3.visible = false
	$InsertCoin2.visible = false
	$PushOnePlayer.visible = false
	$HighScore.visible = true
	$PlayerDemo.visible = false
	$Pug.visible = false
	
func DisableHighScore():
	$HighScore.label_settings.font_color = 'white'
	$Layer0.visible = true
	$PlayerDemo.visible = true
	$Pug.visible = true
	$Instructions1.visible = false
	$Instructions2.visible = false
	$Instructions3.visible = false
	$InsertCoin2.visible = false
	$PushOnePlayer.visible = false
	$HighScore.visible = false
	
func disable_instructions():
	$Instructions1.visible = false
	$Instructions2.visible = false
	$Instructions3.visible = false
	
	
func sort_high_scores():
	high_scores.sort_custom(Callable(self, "_compare_scores"))
	
func _compare_scores(a, b):
	return b["score"] - a["score"] # Sort min to max
	
	
func show_high_scores():
	var score_text = "LVL" + "     " + "SCORE" + "     " + "NAME" + "\n" 
	for i in range(min(5, high_scores.size())):  # Solo muestra los 5 primeros
		var entry = high_scores[i]
		score_text += str(entry["lvl"]) + "     " + str(entry["score"]) + "     " + entry["name"] + "\n"
	$HighScore.text = score_text
	
func endlevel():
	GameManager.level += 1
	get_tree().change_scene_to_file("res://Levels/Level2/level2.tscn")
	#get_tree().quit()

func change_color():
	var random_colour = Color(randf(), randf(), randf())
	return random_colour

func _on_timer_demo_timeout() -> void:
	if stage < 6:
		stage += 1
	else:
		stage = 0
