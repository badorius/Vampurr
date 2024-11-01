extends Node2D

 
#Var enemies to instantiate on level:
@export var level_finished : bool = false
@export var floor : int = 0

#MUSIC VAR
@onready var BgMusic = $BGMusicLVL1
@onready var hud : CanvasLayer = get_node("Hud/")
#Sounds
@onready var insertcoin = $InsertCoin

const Coffin = preload("res://Items/Coffin/Coffin.tscn")
@onready var DoorOut : CharacterBody2D = get_node("DoorOut/")
@onready var DoorIn : CharacterBody2D = get_node("DoorIn/")
@onready var Player : CharacterBody2D = get_node("Player/")


func _ready():
	BgMusic.play()
	DoorIn.open()
	#DoorIn.close()
	GameManager.level = 3

	
func _process(delta: float) -> void:
	if false:
		DoorOut.open()
		
	if DoorOut.IsOpened:
		#print(Player.global_position, DoorOut.global_position)
		if Player.global_position > DoorOut.global_position:
			endlevel()
			

	
func endlevel():
	var FILE_BEGIN = "res://Levels/Level"
	var current_scene_file = get_tree().current_scene.scene_file_path
	print(current_scene_file)
	###FIX TO PENDING - 10 
	var next_level_number = current_scene_file.to_int() + 1 - 10
	print(current_scene_file.to_int())
	var next_level_path = FILE_BEGIN + str(next_level_number) + "/level"+ str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
	#get_tree().quit()
	

func insert_coin():
	if Input.is_action_just_pressed("insertcoin"):
		insertcoin.play()
		GameManager.credits += 1
		hud.update_hud()


		
