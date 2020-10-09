extends PathFollow2D


export (float) var SPEED = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame.
func _physics_process(delta):
	offset += SPEED * delta # Move along the parent Path2D
	
	if unit_offset >= 1:
		path_finished()

# Reached end of path. Remove
func path_finished():
	queue_free()

# Collision with bullet. Remove
func _on_Area2D_body_entered(body):
	queue_free()
