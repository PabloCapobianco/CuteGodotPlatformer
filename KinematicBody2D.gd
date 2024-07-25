extends KinematicBody2D
const acel = 18
const GRAVEDAD = 13
const MAXGRAVEDAD = 150
const SALTO = 400
var perfil = true
var movimiento = false
var saltando = false
var eje_x = 0
var eje_y = 0
var momentum = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	print(is_on_ceiling())

# Salto

	if is_on_floor():
		if saltando == true:
			saltando = false
		if not saltando && Input.is_action_just_pressed("Saltar"):
			momentum.y -= SALTO
			saltando = true
	if Input.is_action_just_released("Saltar") && momentum.y < 0:
		momentum.y = -50

# Perfil	
	if Input.is_action_pressed("ui_right"):
		perfil = true
	elif Input.is_action_pressed("ui_left"):
		perfil = false
	
# Momentum
	var x_input =  Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	momentum.x += x_input * acel
	if momentum.x != 0:
		momentum.x = momentum.x * 0.85
		movimiento = true
		if momentum.x > -8 && momentum.x < 8:
			momentum.x = 0
			movimiento = false
	print(momentum.x) 

# Gravedad
	if is_on_ceiling():
		momentum.y = 0
	momentum.y += GRAVEDAD
	if momentum.y > MAXGRAVEDAD:
		momentum.y = MAXGRAVEDAD

# Animación
	if is_on_floor():
		if movimiento == false:
			$AnimatedSprite.play("Idle")
		else:
			$AnimatedSprite.play("Run")
	else:
		$AnimatedSprite.play("Salto")
		
# Orientación
	if perfil == true:
		$AnimatedSprite.scale.x = 1
	else:
		$AnimatedSprite.scale.x = -1		

	move_and_slide(momentum, Vector2(0, -1))

