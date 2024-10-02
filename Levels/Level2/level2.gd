extends Node2D

 
#Var enemies to instantiate on level:
@export var level_finished : bool = false
@export var floor : int = 0

#MUSIC VAR
@onready var BgMusic = $BGMusicLVL1

# Called when the node enters the scene tree for the first time.

func _ready():
	BgMusic.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if level_finished == true:
		get_tree().quit()

		
