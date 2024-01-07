extends Node2D


signal entered_body(body)
signal leaved_body(body)


func _on_platform_white_area_body_entered(body):
	entered_body.emit(body)


func _on_platform_white_area_body_exited(body):
	leaved_body.emit(body)
