extends PathFollow2D

signal base_damage(amount)

export (float) var speed = 100
export (int) var damage = 1
export (bool) var slime_animation = false

# Related to time control
var speed_multiplier = 1
var time = 0

# Related to slime animation
var original_x_scale = 1
var random_offset = 0
var slime_movement_multiplier = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	original_x_scale = scale.x
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	random_offset = rng.randf_range(-2.0, 2.0)

# Called every frame.
func _physics_process(delta):
	# Move along the parent Path2D
	offset += speed * delta * speed_multiplier * slime_movement_multiplier
	
	if unit_offset >= 1:
		path_finished()

func _process(delta):
	time += delta
	animate_slime()

func animate_slime():
	var sin_input = time*speed_multiplier*3+random_offset
	scale.x = original_x_scale + sin(sin_input)*original_x_scale*0.15
	scale.y = original_x_scale - sin(sin_input)*original_x_scale*0.06
	slime_movement_multiplier = 1 + sin(sin_input) * 0.3

func update_speed_multiplier(new_multiplier):
	time = (time * speed_multiplier) / new_multiplier
	speed_multiplier = new_multiplier
	

# Reached end of path. Remove
func path_finished():
	emit_signal("base_damage", damage)
	queue_free()

# Collision with bullet. Remove
func _on_Area2D_body_entered(body):
	# Remove bullet
	body.queue_free()
	# Remove enemy
	queue_free()
