# GameManager.gd
extends Node

@export var lives : int = 3
@export var score : int = 0
@export var high_score : int = 10000
@export var credits : int = 0
@export var level : int = 0


func add_credits():
	#PENDING Splash coing screen
	credits += 1
	
func del_credits():
	#PENDING Splash coing screen
	credits -= 1
