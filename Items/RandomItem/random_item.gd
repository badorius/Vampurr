extends Node2D

const fish = preload("res://Items/Fish/fish.tscn")
const catfood = preload("res://Items/CataFood/CatFood.tscn")

var items = []


@onready var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items = [fish, catfood, fish, catfood]
	
	# Instanciar un item aleatorio
	var random_item = instantiate_random_item()

	# Añadir el item instanciado a la escena
	add_child(random_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Función que selecciona un item aleatorio y lo instancia
func instantiate_random_item():
	var random_index = randi() % items.size()  # Selecciona un índice aleatorio
	var item_scene = items[random_index]  # Selecciona la escena según el índice
	return item_scene.instantiate()  # Instancia y retorna el item
