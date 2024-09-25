extends CharacterBody2D

#Var state_machine animation
var state_machine



func _ready() -> void:
	randomize() # Neede to  get random spawn each time
	#Assign viewport rect value / 2.0 in order to work between 1 vs -1 
	state_machine = $AnimationTree.get('parameters/playback')
	bubble()




func bubble():
	state_machine.travel('Bubble')
