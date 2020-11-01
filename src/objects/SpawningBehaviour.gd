extends Node2D

signal spawning_complete()

# Mob types supported
enum MobType {
   NONE
   ENEMY
}

# Represents a spawning event
class SpawnObject:
	var time
	var type
	func _init(time, type = MobType.ENEMY):
		self.time = time
		self.type = type
	
var spawning_array = []
var spawn_event_counter = 0

# Create a mapping between the string value of the enum SpawnObject and the enum value
var mob_type_string_mapping = Dictionary()

func setup_enum_string_mapping():
	var i = 0
	for key in MobType.keys():
		mob_type_string_mapping[key] = i
		i += 1

func _ready():
	setup_enum_string_mapping()

# Spawn the mob in line for spawning
func handle_spawn_event():
	var spawn_object = spawning_array[spawn_event_counter]
	if spawn_object.type != MobType.NONE:
		get_parent().spawn()
	spawn_event_counter += 1
	if spawn_event_counter >= spawning_array.size():
		# End of wave
		emit_signal("spawning_complete")
		print("[Level] Wave complete (%s)" % get_parent().BehaviourFile)
	else: # Prepare for next mob
		if spawn_object.time > 0:
			$SpawnTimer.start(spawn_object.time / get_parent().time_scale)
		else:
			handle_spawn_event()
			
# Load the spawning_array from a json file, specified in the parent MobPath
func load_behaviour_from_file(name):
	print("[Level] Loading spawning behaviour: %s" % name)
	if name == "":
		return
	var file = File.new()
	var filename = "res://levels/" + get_parent().BehaviourFile + ".json"
	if file.open(filename, file.READ) != OK:
		print("[Level] Error: Spawning behaviour file ", filename, "does not appear to exist")
		return
	var result_json = JSON.parse(file.get_as_text())
	var result = {}
	if result_json.error == OK:  # If parse OK
		var data = result_json.result
		parse_loaded_behaviour_data(data["behaviour"])
	else:  # If parse has errors
		print("[Level] JSON Parse Error: ", result_json.error)
		print("[Level] Error Line: ", result_json.error_line)
		print("[Level] Error String: ", result_json.error_string)

# Parse the loaded json file into the spawning_array		
func parse_loaded_behaviour_data(json_list):
	for behaviour in json_list:
		if mob_type_string_mapping.has(behaviour[1]):
			for i in range(behaviour[0]): # Iterate over mob count
				var object = SpawnObject.new(behaviour[2], mob_type_string_mapping[behaviour[1]])
				spawning_array.append(object)
		else: #Non-existent mob
			print("[Level] JSON %s contains Mob %s which does not exist" % [get_parent().BehaviourFile, behaviour[1]])
			return
