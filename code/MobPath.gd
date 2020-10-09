extends Path2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Spawn an enemy
func spawn():
	var mob = preload("res://Enemy.tscn").instance()
	add_child(mob)
