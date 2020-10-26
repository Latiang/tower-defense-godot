extends Path2D

export var BehaviourFile = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawningBehaviour.load_behaviour_from_file(BehaviourFile)
	
func start_spawning_time():
	$SpawningBehaviour.handle_spawn_event()

# Spawn an enemy
func spawn():
	var mob = preload("res://objects/Enemy.tscn").instance()
	add_child(mob)

func _on_SpawnTick_timeout():
	$SpawningBehaviour.handle_spawn_event()

func update_time_scale(new_time_scale):
	for child in self.get_children():
		if child.is_in_group("Enemy"):
			child.speed_multiplier = new_time_scale
