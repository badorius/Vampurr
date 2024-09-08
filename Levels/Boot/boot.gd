extends Node2D

var characters = 'abcdefghijklmnopqrstuvwxyz'
@onready var timer = $Timer
@export var stage : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Set all labels as no visible, will be visible on each stage
	$LabelRndChars.visible = false
	$LabelRomCheck.visible = false
	$TileMapLayer.visible = false
	
	randomize()
	timer.start()
	stage = 1
	$LabelRndChars.text=get_rnd_chars(characters, 20)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(stage)
	match stage:
		1:
			print_rnd_chars()
		2:
			RomCheck()
		3:
			showgrid()

	
func print_rnd_chars():
	$LabelRndChars.visible = true
	if $LabelRndChars.text.length() < 400:
		$LabelRndChars.text+=get_rnd_chars(characters, 20)

	else:
		var random_colour = Color(randf(), randf(), randf())
		$LabelRndChars.label_settings.font_color = random_colour
		$LabelRndChars.text=get_rnd_chars(characters, 20)

	
func get_rnd_chars(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word + "\n"

func RomCheck():
	$LabelRndChars.visible = false
	$LabelRomCheck.visible = true
	
	$LabelRomCheck.label_settings.font_color = change_color()
	$LabelRomCheck.text = "RAM CHECK...\n"
	await get_tree().create_timer(0.5).timeout
	$LabelRomCheck.label_settings.font_color = change_color()
	$LabelRomCheck.text += "RAM OK\n"
	await get_tree().create_timer(0.5).timeout
	$LabelRomCheck.label_settings.font_color = change_color()
	$LabelRomCheck.text += "ROM CHECK...\n"
	await get_tree().create_timer(0.5).timeout
	$LabelRomCheck.label_settings.font_color = change_color()
	$LabelRomCheck.text += "ROM OK\n"
	await get_tree().create_timer(0.5).timeout
	stage +=1


func change_color():
	var random_colour = Color(randf(), randf(), randf())
	return random_colour


func showgrid():
	$LabelRndChars.visible = false
	$LabelRomCheck.visible = false
	$TileMapLayer.visible = true
	
func quitboot():
	get_tree().quit()

	

func _on_time_rnd_chars_timeout() -> void:
	if stage < 3:
		stage += 1
	else:
		quitboot()
	 
