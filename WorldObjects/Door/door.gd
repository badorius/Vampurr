extends CharacterBody2D

var state_machine
@export var status = "Closed"


# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $AnimationTree.get('parameters/playback')

	open()
	close()
	
func open():
	state_machine.travel('Open')
	status = "Opened"

func close():
	state_machine.travel('Close')
	status = "Closed"
