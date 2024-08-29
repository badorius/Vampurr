extends Node2D

func _ready():
	print("Main scene is ready!")
	load_level("res://Levels/Level1/level_1.tscn")

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
