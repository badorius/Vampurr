extends CharacterBody2D
var maxup = 10
var maxdown = 10
const POINTS : int = 500
const SPEED = 30.0
const JUMP_VELOCITY = -300.0
const PointsIndicator = preload("res://Hud/points_indicator.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


#Vars to Wave y movement
var bob_height : float = 3.0
var bob_speed : float = 8.0
var t : float = 0.0

@onready var hud : CanvasLayer = get_node("../Hud")
@onready var sound = $Pickup


# Called when the node enters the scene tree for the first time.
func _ready():
	#SONIDOS
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		sound.play()
		
		#FIX Random size
		var offset_position = randi() % 20
		var main = get_tree().current_scene
		var points = PointsIndicator.instantiate()
		var color = "white"
		points.global_position = Vector2(global_position.x - offset_position, (global_position.y) - offset_position)
		points.show_points(POINTS, color)
		main.add_child(points)

		GameManager.score += POINTS
		hud.update_hud() 
		queue_free()
