extends CharacterBody2D



const SPEED: int = 600
var delta_value

func _process(delta):
	delta_value = delta
	
	#let_him_move()
	manage_move_to_click()
	manage_rotation()
	manage_scale(delta)
	
	register_left_click()
	register_right_click()
	register_f_input(300) # input boundary teleportation
	register_s_input()
	register_a_input()
	register_w_input()
	
	if start_decreasing: decrease_fast()
	if start_increasing: increase_fast()
	if speedTime: spin_boy()
	
	print()
	print(get_global_mouse_position())
	print(get_local_mouse_position())
	












# ------------------------------------------------------------------------------------------------------------
# SKILL
signal skill_1(pos, direction)
signal skill_2(pos, direction)

func register_a_input():
	if Input.is_action_just_pressed("Q"):
		var selected_marker = $BlastRedMarkers.get_children()[randi() % $BlastRedMarkers.get_children().size()]
		var spawn_position = selected_marker.global_position
		var direction = (get_global_mouse_position() - position).normalized()
		var speed = 600
		var delay = 0.1
		
		
		# Emit to World Node
		skill_1.emit(spawn_position, direction, speed, delay)
		
		# Stop Player
		#position_goal = position


#var status: int = -1 # for the Ordered Positioning
#func register_w_input():
	#if Input.is_action_just_pressed("2"):
		## Ordered Positioning
		#if status >= ($BallRedMarkers.get_children().size() - 2): status = -1
		#else: status += 1
		#
		## Emit to World Node
		##var direction: Vector2 = (get_global_mouse_position() - position).normalized()
		#var spawn_position = $BallRedMarkers.get_children()[status].global_position
		##skill_2.emit(spawn_position, direction)
		#skill_2.emit(spawn_position)

# Auto Loop
func register_w_input():
	if Input.is_action_just_pressed("W"):
		for e in $BallRedMarkers.get_children():
			# Emit to World Node
			var direction: Vector2 = (get_global_mouse_position() - position).normalized()
			var spawn_position = e.global_position
			var speed = 400
			
			#skill_2.emit(spawn_position)
			skill_2.emit(spawn_position, direction, speed)










# ------------------------------------------------------------------------------------------------------------
# ROTATE
var rotation_to_position: bool = true
func manage_rotation():
	if rotation_to_position == true:
		look_at(get_global_mouse_position())
		rotation_degrees += 90

var speedTime: bool = false
func spin_boy():
	if speedTime:
		rotation_degrees += 50











# ------------------------------------------------------------------------------------------------------------
# ATTACK
signal just_attacked

func register_left_click():
	if Input.is_action_just_pressed("left_click"):
		just_attacked.emit()
		
		# Stop Movement
		if position.distance_to(position_goal) < 200:
			keep_moving = false










# ------------------------------------------------------------------------------------------------------------
# SCALE
# ATTRIBUTES
var scale_speed: Vector2 = Vector2(0.06,0.06)
const SCALE_BASE: Vector2 = Vector2.ONE
const SCALE_MAX: Vector2 = Vector2(1.1,1.1)
var increase: bool = false

# Main Method
func manage_scale(delta):
	if scale_switcher:
		if scale <= SCALE_BASE:
			increase = true
		elif scale >= SCALE_MAX:
			increase = false
		if increase:
			increase_scale(Vector2(0.06,0.06), delta)
		else:
			decrease_scale(Vector2(0.06,0.06), delta)
	else:
		if scale > SCALE_BASE:
			decrease_scale(Vector2(0.06,0.06), delta)

# FUNTIONAL METHODS
func increase_scale(scale_speed, delta):
	scale += (scale_speed * delta)

func decrease_scale(scale_speed, delta):
	scale -= (scale_speed * delta)

var scale_switcher = false
func switch_scale():
	if scale_switcher: scale_switcher = false
	else: scale_switcher = true










# ------------------------------------------------------------------------------------------------------------
# MOVEMENT
# WASD - MOVEMENT
# ATTRIBUTES
# MAIN METHOD
func let_him_move():
	velocity = register_direction() * SPEED
	move_and_slide()
# FUNCTIONAL METHODS
func register_direction():
	return Input.get_vector("left", "right", "up", "down")
func move_body(direction, delta):
	position += direction * SPEED * delta



# CLICK TO MOVE -------------------------------------------------
var position_goal: Vector2
var keep_moving: bool = true

var fix_starting_position: bool = true
func set_fix_starting_position():
	position_goal = position

func manage_move_to_click():
	# Fix Position
	if fix_starting_position:
		set_fix_starting_position()
		fix_starting_position = false
	
	# Move
	if position.distance_to(position_goal) > 3 and keep_moving:
		var direction: Vector2 = (position_goal - position).normalized()
		velocity = direction * SPEED
		move_and_slide()
	# Stop
	else:
		position_goal = position

func register_right_click():
	if Input.is_action_pressed("right_click"):
		position_goal = get_global_mouse_position()
		keep_moving = true

func register_s_input():
	if Input.is_action_just_pressed("S"):
		keep_moving = false










 #TELEPORT -----------------------------------------------------
var temp001
func register_f_input(boundary):
	if Input.is_action_just_pressed("F"):
		start_decreasing = true
		speedTime = true
		rotation_to_position = false
		temp001 = boundary

var start_decreasing: bool = false
func decrease_fast():
	if scale <= Vector2.ZERO: 
		start_decreasing = false
		start_increasing = true
		rotation_to_position = false
		teleportation(temp001)
	else: 
		decrease_scale(Vector2(3,3), delta_value)

var start_increasing: bool = false
func increase_fast():
	if scale >= SCALE_BASE:
		start_increasing = false
		rotation_to_position = true
		speedTime = false
		#speed
	else:
		increase_scale(Vector2(3,3), delta_value)

func teleportation(boundary):
	# Check max range
	var mouse_position = get_global_mouse_position()
	var too_far_x = abs(mouse_position.x - position.x) >= boundary
	var too_far_y = abs(mouse_position.y - position.y) >= boundary
	
	# Teleport at max range
	if too_far_x or too_far_y:
		var direction = (mouse_position - position).normalized()
		var new_pos: Vector2 = position + direction * boundary
		position_goal = new_pos
		position = new_pos
	
	# Teleport on click
	else:
		position_goal = mouse_position
		position = mouse_position
