extends CharacterBody2D

#Var state_machine animation
var state_machine
@export var is_dead : bool = false



func _ready() -> void:
	randomize() # Neede to  get random spawn each time
	#Assign viewport rect value / 2.0 in order to work between 1 vs -1 
	state_machine = $AnimationTree.get('parameters/playback')
	bubble()
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true

func bubble():
	state_machine.travel('Bubble')

func die():
	get_tree().quit()
