extends KinematicBody2D
const ACEL = 16
const GRAVEDAD = 8.5
const MAXGRAVEDAD = 105
const SALTO = 300

#VARIABLES DE ANIMACIÓN
var perfil = true
var movimiento = false
var eje_x = 0
var eje_y = 0
var momentum = Vector2()
var colliding = false
var can_dash = true
var dashing = false
var x_input = 0
var y_input = 0
var dash_impulse = 300
var delta_collision_shape
var checkpoint = position
onready	var parent = get_parent()
onready var polvo = preload("res://Polvo.tscn")
onready var dash_timer = $Dash_timer
onready var collision_shape = $CollisionShape2D

func Left_colliding():
	return $"Col_izquierda".is_colliding() && Input.get_action_strength("ui_left") > 0

func Right_colliding():
	return $"Col_derecha".is_colliding() && Input.get_action_strength("ui_right")  > 0

func Gravedad():
	momentum.y += GRAVEDAD
	if momentum.y > MAXGRAVEDAD:
		momentum.y = MAXGRAVEDAD
	if not is_on_floor() && colliding && momentum.y > 0:
		momentum.y = momentum.y * 0.5

func Salto():
	if is_on_floor():
		if Input.is_action_just_pressed("Saltar"):
			momentum.y -= SALTO
			Efecto_salto()
	if not is_on_floor():
		if Input.is_action_just_pressed("Saltar"):
			if $"Col_izquierda".is_colliding():
				momentum.y -= SALTO*0.55
				momentum.x +=140
				Efecto_salto()
			if $"Col_derecha".is_colliding():
				momentum.y -= SALTO*0.55
				momentum.x -=140
				Efecto_salto()

		if Input.is_action_just_released("Saltar") && momentum.y < 0:
			momentum.y = -50
		if is_on_ceiling() && momentum.y < 0:
			momentum.y = 0


func Efecto_salto():
	var efecto_polvo = polvo.instance()
	get_tree().get_root().add_child(efecto_polvo)		
	efecto_polvo.position = position			

func Desplazamiento():
	momentum.x += ACEL * x_input
	momentum.x = int(momentum.x *0.75)
	

func Animate():
	if Input.is_action_just_pressed("ui_right"):
		perfil = true
	if Input.is_action_just_pressed("ui_left"):
		perfil = false		
	if is_on_floor():	
		if momentum.x != 0:
			$AnimatedSprite.play("Run")
		else:
			$AnimatedSprite.play("Idle")
	elif colliding:
		$AnimatedSprite.play("Colliding")
	else:
		$AnimatedSprite.play("Salto")
	if perfil:
		$AnimatedSprite.scale.x = 1
	if not perfil:
		$AnimatedSprite.scale.x = -1
# Orientación
		
func Position():
	if global_position.y > 180:
		set_position(checkpoint)

func Collision_shape():
	if perfil:
		collision_shape.global_transform.origin[0] = global_transform.origin[0] + 1.6
	else:
		collision_shape.global_transform.origin[0] = global_transform.origin[0] - 1.6	
#	if perfil && Input.is_action_just_pressed("ui_left") :
#		$CollisionShape2D.translate(Vector2(-3.2,0))
#	if not perfil && Input.is_action_just_pressed("ui_right") :
#		$CollisionShape2D.translate(Vector2(3.2,0))				

func Impulso_dash():  
	if y_input != 0:
		if x_input != 0:
			momentum.x = dash_impulse * x_input * 0.6
			momentum.y = dash_impulse * y_input * 0.6
		else:
			momentum.y = dash_impulse * y_input * 0.7
	else:
		if x_input != 0:
			momentum.x = dash_impulse * x_input
			momentum.y = 0
		else:
			if perfil: 
				momentum.x = dash_impulse
			else:
				momentum.x = -dash_impulse
	dashing = true


func Dash():
	if not dashing:
		if not can_dash && is_on_floor():
			can_dash = true
		elif can_dash && Input.is_action_just_pressed("Dash"):
			Impulso_dash()
			can_dash = false
			dash_timer.wait_time = 0.03
			dash_timer.start()
	elif dashing and dash_timer.is_stopped():          
		dashing = false


func Perfil():
	if Input.is_action_pressed("ui_right"):
		perfil = true
	if Input.is_action_pressed("ui_left"):
		perfil = false

func Inputs():
	x_input =  Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")	
	y_input =  Input.get_action_strength("ui_down")	- Input.get_action_strength("ui_up")


func _process(delta):
	colliding = Left_colliding() or Right_colliding()
#	print(colliding)
	Collision_shape()
	Perfil()
	Dash()
	if not dashing:
		Inputs()
		Desplazamiento()
		Gravedad()
		Salto()
	Animate()
	Position()

	move_and_slide(momentum, Vector2(0, -1))

