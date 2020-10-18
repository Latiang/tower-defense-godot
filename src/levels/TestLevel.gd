extends Node

var wave_started = false

# Level start.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartButton_pressed():
	$CodeWindow/Panel.visible = false
	wave_started = true
	$MobPath1.start_spawning_time()
	$MobPath2.start_spawning_time()


func _on_CodeWindow_save_and_close(new_code_source):
	$Turret/ProgrammableBehaviour/CodeInterpreter.code_source = new_code_source
	$CodeWindow/Panel.visible = false
