extends Node2D

 
#Var enemies to instantiate on level:
@export var level_finished : bool = false
@export var floor : int = 0

#MUSIC VAR
@onready var BgMusic = $BGMusicLVL1



func _ready():
	BgMusic.play()
	
func _physics_process(delta: float) -> void:
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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if level_finished == true:
		get_tree().quit()

		
