extends CharacterBody2D


func _process(delta):
	manage_scale(delta)
	#let_him_move()
	


# ------------------------------------------------------------------------------------------------------------
# SCALE
# ATTRIBUTES
var scale_speed: Vector2 = Vector2(0.04,0.04)
const SCALE_BASE: Vector2 = Vector2.ONE
const SCALE_MAX: Vector2 = Vector2(1.1,1.1)
var increase: bool = false

# Main Method
func manage_scale(delta):
	if scale <= SCALE_BASE:
		increase = true
	elif scale >= SCALE_MAX:
		increase = false
	if increase:
		increase_scale(delta)
	else:
		decrease_scale(delta)

# FUNTIONAL METHODS
func increase_scale(delta):
	scale += (scale_speed * delta)

func decrease_scale(delta):
	scale -= (scale_speed * delta)
