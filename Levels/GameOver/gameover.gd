extends Node2D

@onready var timer = $Timer
var state_machine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Set all labels as no visible, will be visible on each stage
	randomize()
	timer.start()


func change_color():
	var random_colour = Color(randf(), randf(), randf())
	return random_colour

func endlevel():
	get_tree().change_scene_to_file("res://Levels/Level1/level1.tscn")
	#get_tree().quit()


func _on_timer_timeout() -> void:
		endlevel()
