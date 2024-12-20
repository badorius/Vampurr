extends Control

@onready var player : CharacterBody2D = get_node("../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasModulate2.color = change_color()

	if Input.is_action_just_pressed("ui_cancel"):
		player.game_unpause()
		get_tree().paused = false

func _on_resume_pressed():
	player.game_unpause()
	get_tree().paused = false


func _on_exit_game_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Levels/Level1/level1.tscn")
	
func change_color():
	var random_colour = Color(randf(), randf(), randf())
	return random_colour
