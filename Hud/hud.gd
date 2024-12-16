extends CanvasLayer

@export var lives : int = 3
@export var score : int = 0
@export var high_score : int = 10000
@export var timer : float = 300.0
@export var timer_status : bool = true
@export var credits : int = 0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_hud()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if timer_status:
		update_timer()
		

func stop_timer():
	timer_status = false
	$Time.text = str(int(0))
	
func update_timer():
	var tmp_time = float($Time.text) 
	timer -= 0.02
	$Time.text = str(int(timer))

func update_hud():
	lives = GameManager.lives
	credits = GameManager.credits
	high_score = GameManager.high_score
	score = GameManager.score
	
	match lives:
		0:
			$BoxContainerLives/IconLive3.visible = false
			$BoxContainerLives/IconLive2.visible = false
			$BoxContainerLives/IconLive1.visible = false

		1:
			$BoxContainerLives/IconLive2.visible = false
			$BoxContainerLives/IconLive3.visible = false
		2:
			$BoxContainerLives/IconLive3.visible = false
			
	$Credits.text = str(credits)
	$Socre.text = str(score)

	
	
