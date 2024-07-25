extends KinematicBody2D

var desplazamiento =-10

func _process(delta):
	global_position.y += desplazamiento * delta
	$Estrella.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.

	
