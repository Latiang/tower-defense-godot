extends PathFollow2D

signal base_damage(amount)

export (float) var speed = 100
export (int) var damage = 1

var speed_multiplier = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame.
func _physics_process(delta):
	offset += speed * delta * speed_multiplier # Move along the parent Path2D
	
	if unit_offset >= 1:
		path_finished()

# Reached end of path. Remove
func path_finished():
	emit_signal("base_damage", damage)
	queue_free()

# Collision with bullet. Remove
func _on_Area2D_body_entered(body):
	# Remove bullet
	body.queue_free()
	# Remove enemy
	queue_free()
