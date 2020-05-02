extends KinematicBody



onready var Camera = $Pivot/Camera
onready var Flash = $Pivot/Flash
onready var Smoke = $Pivot/Smoke
var Bullet = preload("res://Scenes/Bullet.tscn")



var velocity = Vector3()
var gravity = -9.8
var speed = 8
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var jump = 3
var jumping = false

var has_key = false
var has_crate = false

var health = 100

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func take_damage(d):
	health -= d
	if health <= 0:
		get_node("/root/Game/HUD/Lose").visible = true
		get_node("/root/Game/HUD/Time").visible = false
		get_node("/root/Game/HUD/Timer").stop()
	var m = $Pivot/Life.get_surface_material(0)
	var v = (100.0 - float(health)) / 300.0
	m.albedo_color = Color(0.8,0,0,v)
	$Pivot/Life.set_surface_material(0, m)



func update_crate():
	has_crate = true
	get_node("/root/Game/HUD/Time/Crate").add_color_override("font_color",Color(1,1,0,1))
	get_node("/root/Game/Enemies/Tank").health = 5

func update_key():
	has_key = true
	get_node("/root/Game/HUD/Time/Key").add_color_override("font_color",Color(1,1,0,1))

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	if Input.is_action_pressed("jump"):
		jumping = true
	input_dir = input_dir.normalized()
	return input_dir




func _physics_process(delta):
	if health <= 0:
		return
	velocity.y += gravity * delta
	var desired_velocity = get_input() * speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	if jumping and is_on_floor():
		velocity.y = jump
	jumping = false
	velocity = move_and_slide(velocity, Vector3.UP, true)



func _unhandled_input(event):
	if health <= 0:
		return
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)
	if event.is_action_pressed("shoot") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var b = Bullet.instance()
		b.start($Pivot/Muzzle.global_transform)
		Flash.emitting = true
		Smoke.emitting = true
		get_node("/root/Game/Bullets").add_child(b)
		

