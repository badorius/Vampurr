extends CharacterBody2D

var state_machine
@export var IsOpened : bool = false
@export var IsClosed : bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $AnimationTree.get('parameters/playback')

	
func open():
	state_machine.travel('Open')
	IsOpened = true
	IsClosed = false
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	
func close():
	state_machine.travel('Close')
	IsOpened = false
	IsClosed = true
	$CollisionShape2D.disabled = false
	$Area2D/CollisionShape2D.disabled = true
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.level_finished = true
		print("Level Finished")
