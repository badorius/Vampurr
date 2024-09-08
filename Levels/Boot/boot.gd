extends Node2D

var characters = 'abcdefghijklmnopqrstuvwxyz'
@export var new_string : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_string = print_random_chars(characters, 16)
	print(new_string)
	$Label.text=new_string

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	new_string = print_random_chars(characters, 16)
	$Label.text=new_string + "\n"

func print_random_chars(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word
