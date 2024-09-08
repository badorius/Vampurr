extends CanvasLayer

@export var lives : int = 3
@export var score : int = 0
@export var high_score : int = 10000
@export var timer : float = 300.0
@onready var player : CharacterBody2D = get_node("../Player")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func dead(player_lives):
	lives = player_lives
	match lives:
		0:
			$BoxContainerLives/IconLive3.visible = false
		1:
			$BoxContainerLives/IconLive2.visible = false
		2:
			$BoxContainerLives/IconLive1.visible = false

	
	
