extends TouchScreenButton

#var viewport_rect = get_viewport_rect()
#onready var character_node = get_node("/root/Node2D/Personaje")
#onready var camera = character_node.get_node("Camera2D")

#func _process(delta):
#	var camera_position = camera.global_position.y	
#	var position = Vector2(140, camera_position)
#	print(camera_position)
#	var viewport_position = viewport_rect.position
#	var position = viewport_position - Vector2(-80, 20)

	# Obtener la posición de la cámara
	
#	var camera_position = camera.global_position
#	var position = camera_position + relative_position
#	print(relative_position, camera_position)
	# Fijar la posición del botón en relación con la cámara
#	set_position(position)
