extends KinematicBody2D

var desplazamiento = 15

func _process(delta):
	global_position.x += desplazamiento * delta
	if global_position.x > 150:
		 global_position.x = -20
	
	$AnimatedSprite.play("moving")
