extends Node

var wave_started = false

signal open_code_window(turret)

# Level start.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func close():
	queue_free()

func start_wave():
	wave_started = true
	$MobPath1.start_spawning_time()
	$MobPath2.start_spawning_time()

func _on_Turret_turret_pressed(turret):
	emit_signal("open_code_window", turret)
