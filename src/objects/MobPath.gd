extends Path2D

export var BehaviourFile = ""

var time_scale = 1
var spawning_complete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawningBehaviour.load_behaviour_from_file(BehaviourFile)
	
func start_spawning_time():
	$SpawningBehaviour.handle_spawn_event()

# Spawn an enemy
func spawn():
	var mob = preload("res://objects/GruntEnemy.tscn").instance()
	mob.speed_multiplier = time_scale
	mob.connect("base_damage", get_parent().get_parent(), "_on_Level_base_damage")
	add_child(mob)

func _on_SpawnTick_timeout():
	$SpawningBehaviour.handle_spawn_event()

func update_time_scale(new_time_scale):
	# Modify SpawnTimer if active
	if $SpawningBehaviour/SpawnTimer.time_left > 0:
		var new_time = $SpawningBehaviour/SpawnTimer.time_left * (float(time_scale) / new_time_scale)
		$SpawningBehaviour/SpawnTimer.start(new_time)
	time_scale = new_time_scale
	# Modify spawned enemies
	for child in self.get_children():
		if child.is_in_group("Enemy"):
			child.update_speed_multiplier(new_time_scale)
	

func _on_SpawningBehaviour_spawning_complete():
	spawning_complete = true
