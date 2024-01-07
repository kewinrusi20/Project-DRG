extends Node2D


func _on_platform_white_entered_body(body):
	$Player.scale_switcher = true
	print("Save Point Entered")


func _on_player_just_attacked():
	print('just attacked')


func _on_platform_white_leaved_body(body):
	$Player.scale_switcher = false
	pass # Replace with function body.


# ------------------------------------------------------------------------------------------------------------
# RED SLIME
# ATTRIBUTES
var blast_red: PackedScene = preload("res://scenes/blast_red/blast_red.tscn")
var ball_red: PackedScene = preload("res://scenes/ball_red/ball_red.tscn")


# FUNCTIONAL METHODS
func _on_player_skill_1(pos, direction, speed, delay):
	var instance = blast_red.instantiate()
	instance.direction = direction
	instance.position = pos
	instance.speed = speed
	instance.delay = delay
	
	add_child(instance)


# extra method
# to add position and direction
func create_all_blast_red(blast_red_position):
	for e in blast_red_position:
		var instance_of_blast_red = blast_red.instantiate() as StaticBody2D
		instance_of_blast_red.position = e.global_position
		add_child(instance_of_blast_red)


func _on_player_skill_2(pos, direction, speed):
	var instance = ball_red.instantiate() as RigidBody2D
	instance.position = pos
	instance.linear_velocity = direction * speed
	add_child(instance)
