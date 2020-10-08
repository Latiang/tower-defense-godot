extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bullet_speed = 500
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity)

# Remove object when not inside the screen area
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
