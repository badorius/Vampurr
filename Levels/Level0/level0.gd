extends Node2D

var characters = 'abcdefghijklmnopqrstuvwxyz'
@export var stage : int
@onready var timer = $Timer
var state_machine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine = $AnimationTree.get('parameters/playback')
	#Set all labels as no visible, will be visible on each stage
	disable_visible()
	randomize()
	timer.start()
	stage = 1
	$LabelRndChars.text=get_rnd_chars(characters, 40)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	print(stage)
	match stage:
		1:
			print_rnd_chars()
		2:
			RomCheck1()
		3:
			RomCheck2()
		4:
			RomCheck3()
		5:
			RomCheck4()
		6:
			showgrid()
		7:
			showsplash()


	
func print_rnd_chars():
	$LabelRndChars.visible = true
	if $LabelRndChars.text.length() < 800:
		$LabelRndChars.text+=get_rnd_chars(characters, 40)

	else:
		var random_colour = Color(randf(), randf(), randf())
		$LabelRndChars.modulate =  random_colour
		$LabelRndChars.text=get_rnd_chars(characters, 40)
		$LabelRndChars.visible = false

	
func get_rnd_chars(chars, length):
	var word: String = ""
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word + "\n"

func RomCheck1():
	$LabelRndChars.visible = false
	$LabelRomCheck.visible = true
	$LabelRomCheck.label_settings.font_color = change_color()
	$LabelRomCheck.text = "RAM CHECK...\n"

	
func RomCheck2():
	$LabelRomCheck.label_settings.font_color = change_color()
	$LabelRomCheck.text = "RAM CHECK...\n" + "RAM OK\n"

	
func RomCheck3():
	$LabelRomCheck.label_settings.font_color = change_color()
	$LabelRomCheck.text = "RAM CHECK...\n" + "RAM OK\n" + "ROM CHECK...\n"

func RomCheck4():
	$LabelRomCheck.text = "RAM CHECK...\n" + "RAM OK\n" + "ROM CHECK...\n" + "ROM OK\n"

func change_color():
	var random_colour = Color(randf(), randf(), randf())
	return random_colour


func showgrid():
	disable_visible()
	$TileMapLayer.visible = true
	
	
func showsplash():
	disable_visible()
	$Splash.visible = true
	state_machine.travel('splash')
	$Hud.visible = true
	
func disable_visible():
	$LabelRndChars.visible = false
	$LabelRomCheck.visible = false
	$TileMapLayer.visible = false
	$Splash.visible = false
	$Hud.visible = false
	$Player.visible = false
	
func endlevel():
	GameManager.level += 1
	var FILE_BEGIN = "res://Levels/Level"
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + GameManager.level
	var next_level_path = FILE_BEGIN + str(next_level_number) + "/level"+ str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
	#get_tree().quit()




func _on_timer_timeout() -> void:
	if stage < 8:
		stage += 1
	else:
		endlevel()
