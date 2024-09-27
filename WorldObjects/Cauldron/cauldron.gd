extends CharacterBody2D

#Var state_machine animation
var state_machine
@export var is_dead : bool = false
@export var green_bubble: PackedScene = preload("res://WorldObjects/GreenBubbles/GreenBubbles.tscn")



func _ready() -> void:
	randomize() # Neede to  get random spawn each time
	#Assign viewport rect value / 2.0 in order to work between 1 vs -1 
	state_machine = $AnimationTree.get('parameters/playback')
	bubble()
	state_machine.travel('Iddle')



func explode():
	#Pending animation explode to open crucifyx dors
	is_dead = true


func bubble():
	var green_bubble = green_bubble.instantiate()
	green_bubble.global_position = global_position
	add_child(green_bubble)
	#Pass rect value to pug in order to get movement inteligence depending of sice window
