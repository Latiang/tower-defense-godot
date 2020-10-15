extends Area2D

func _ready():
	pass

# Returns true or false depending on if an enemy is colliding with SensorCast
func detect():
	return $SensorCast.is_colliding()
