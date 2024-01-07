extends Area2D

var direction
var delay
var speed


func _ready():
	set_angle()

var delta_value
func _process(delta):
	delta_value = delta
	
	delated_shot()



var start_timer: bool = true
func delated_shot():
	if start_timer:
		$Timer.set_wait_time(delay)
		$Timer.set_one_shot(true)
		$Timer.start()
		start_timer = false
		
	if $Timer.is_stopped():
		position += speed * direction * delta_value


func set_angle():
	#look_at(get_global_mouse_position())
	rotation_degrees = rad_to_deg(direction.angle())
	
	rotation_degrees += 90
