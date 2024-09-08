extends Node2D

@export var num_levels: int = 2
@onready var currentlevel : int = 0




func _ready():
	#load_level("res://Levels/Level1/level_1.tscn")
	load_level("res://Levels/Level0/level0.tscn")

func load_level(level_path: String):
	var level_scene = load(level_path)
	# Verificar si la escena se carga correctamente
	if level_scene == null:
		print("Error: No se pudo cargar la escena desde ", level_path)
		return
	
	var level_instance = level_scene.instantiate()
	print("Level Scene: ", level_scene)
	print("Level Instance: ", level_instance)
	
	add_child(level_instance)
	
func _process(_delta):
	pass
