extends Area2D

func _ready():
	pass
	

# Returns true or false depending on if an enemy is colliding with SensorCast
func detect():
	if $SensorCast.is_colliding():
		return $SensorCast.get_collision_point().distance_to(position)
	else:
		return false
