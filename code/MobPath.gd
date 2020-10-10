extends Path2D

export var BehaviourFile = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawningBehaviour.load_behaviour_from_file(BehaviourFile)
	
func start_spawning_time():
	$SpawningBehaviour.handle_spawn_event()

# Spawn an enemy
func spawn():
	var mob = preload("res://Enemy.tscn").instance()
	add_child(mob)

func _on_SpawnTick_timeout():
	$SpawningBehaviour.handle_spawn_event()
