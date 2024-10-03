extends Node2D

 
#Var enemies to instantiate on level:
@export var level_finished : bool = false
@export var floor : int = 0

#MUSIC VAR
@onready var BgMusic = $BGMusicLVL1

@onready var Cauldron1 : CharacterBody2D = get_node("../Cauldron1")
@onready var Cauldron2 : CharacterBody2D = get_node("../Cauldron2")
@onready var Cauldron3 : CharacterBody2D = get_node("../Cauldron3")

@onready var Crucifix1_floor1 : CharacterBody2D = get_node("../Crucifix1_floor2")
@onready var Crucifix2_floor1 : CharacterBody2D = get_node("../Crucifix2_floor2")
@onready var Crucifix1_floor2 : CharacterBody2D = get_node("../Crucifix1_floor2")
@onready var Crucifix2_floor2 : CharacterBody2D = get_node("../Crucifix2_floor2")
@onready var Crucifix3_floor2 : CharacterBody2D = get_node("../Crucifix3_floor2")
@onready var Crucifix4_floor2 : CharacterBody2D = get_node("../Crucifix4_floor2")
@onready var Crucifix1_floor3 : CharacterBody2D = get_node("../Crucifix1_floor3")
@onready var Crucifix2_floor3 : CharacterBody2D = get_node("../Crucifix2_floor3")

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

		
