extends Node2D

 
#Var enemies to instantiate on level:
@export var level_finished : bool = false
@export var floor : int = 0

#MUSIC VAR
@onready var BgMusic = $BGMusicLVL1
@onready var hud : CanvasLayer = get_node("Hud/")
#Sounds
@onready var insertcoin = $InsertCoin


func _ready():
	BgMusic.play()
	
func _physics_process(delta: float) -> void:
	insert_coin()
	if $Cauldron1.is_shed: 
		$Crucifix1_floor1.inverted()
		$Crucifix2_floor1.inverted()
	if $Cauldron2.is_shed: 
		$Crucifix1_floor2.inverted()
		$Crucifix2_floor2.inverted()
		$Crucifix3_floor2.inverted()
		$Crucifix4_floor2.inverted()
	if $Cauldron3.is_shed: 
		$Crucifix1_floor3.inverted()
		$Crucifix2_floor3.inverted()
	
	
func insert_coin():
	if Input.is_action_just_pressed("insertcoin"):
		insertcoin.play()
		GameManager.credits += 1
		hud.update_hud()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if level_finished == true:
		get_tree().quit()

		
