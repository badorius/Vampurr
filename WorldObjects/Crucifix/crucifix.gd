extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var is_inverted : bool = false

@onready var player : CharacterBody2D = get_node("../Player")
@export var is_near_player : bool = false


func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and is_inverted:
		$Area2D/CollisionShape2D.disabled = true
		#$CollisionShape2D.disabled = true
		velocity += get_gravity() * delta
		move_and_slide()
		
		
func inverted():
	$Crucifix.visible = false
	$CrucifixInverted.visible = true
	is_inverted = true
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
