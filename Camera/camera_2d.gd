extends Camera2D

@onready var player : CharacterBody2D = get_node("../Player")
var screen_size  # Tamaño de la pantalla
var flor_level = 0  # Nivel actual del suelo (base de la cámara)

# Llamado al entrar en la escena
func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size  # Tamaño visible de la pantalla

# Llamado cada frame
func _process(delta: float) -> void:
	pass
	"""
	# Si el jugador ha alcanzado el límite superior de la pantalla, subir la cámara
	if player.global_position.y <= flor_level - screen_size.y / 2:
		flor_level -= screen_size.y  # Subir un bloque completo de pantalla
		global_position.y = flor_level

	# Si el jugador ha alcanzado el límite inferior de la pantalla, bajar la cámara
	elif player.global_position.y > flor_level + screen_size.y / 2:
		flor_level += screen_size.y  # Bajar un bloque completo de pantalla
		global_position.y = flor_level
	"""
