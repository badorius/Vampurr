extends Node2D


#MUSIC VAR
@onready var BgMusic = $BGMusicLVL1

# Called when the node enters the scene tree for the first time.

func _ready():
	BgMusic.play()
	print("music")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
