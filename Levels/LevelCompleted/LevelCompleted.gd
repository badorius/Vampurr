extends Node2D

@onready var timer = $Timer
var state_machine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Set all labels as no visible, will be visible on each stage
	randomize()
	timer.start()

func _process(delta):
	$LevelCompleted/LevelCompleted.label_settings.font_color = change_color()

func change_color():
	var random_colour = Color(randf(), randf(), randf())
	return random_colour


func endlevel():
	GameManager.level += 1
	var FILE_BEGIN = "res://Levels/Level"
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + GameManager.level
	var next_level_path = FILE_BEGIN + str(next_level_number) + "/level"+ str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
	#get_tree().quit()

func _on_timer_timeout() -> void:
		endlevel()
