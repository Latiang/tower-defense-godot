extends Node

var wave_started = false

signal open_code_window(turret)

# Level start.
func _ready():
	pass

func close():
	queue_free()

func start_wave():
	wave_started = true
	$MobPath1.start_spawning_time()

func _on_Turret_turret_pressed(turret):
	emit_signal("open_code_window", turret)


func _on_Turret2_turret_pressed(turret):
	emit_signal("open_code_window", turret)
