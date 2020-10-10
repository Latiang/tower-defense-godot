extends Node


# Level start.
func _ready():
	$MobPath1.start_spawning_time()
	$MobPath2.start_spawning_time()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
