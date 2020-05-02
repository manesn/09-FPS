extends KinematicBody

# States
# searching
# found
# shooting



var state = ""
var speed = 1
onready var Scan = $Scanner
onready var L = $Scanner_l
onready var R = $Scanner_r
onready var Indicator = $Indicator
var Bullet = preload("res://Scenes/EnemyBullet.tscn")
var health = 1000


func take_damage(d):
	health -= d
	if health <= 0:
		queue_free()
		get_node("/root/Game/HUD/Win").visible = true
		get_node("/root/Game/HUD/Time").visible = false
		get_node("/root/Game/HUD/Timer").stop()

func change_state(s):
	state = s
	if state == "searching":
		Indicator.light_color = Color(0,1,0)
	if state == "found":
		Indicator.light_color = Color(1,1,0)
	if state == "shooting":
		Indicator.light_color = Color(1,0,0)


func _ready():
	change_state("searching")

func _physics_process(delta):
	if state == "searching":
		rotate(Vector3(0, 1, 0), speed*delta)
		var c = Scan.get_collider()
		if c != null and c.name == 'Player':
			change_state("found")
	else:
		var l = L.get_collider()
		if l != null and l.name == 'Player':
			speed = 1
		var r = R.get_collider()
		if r != null and r.name == 'Player':
			speed = -1
	if state == "found":
		change_state("waiting")
		$Timer.start()
	if state == "shooting":
		var b = Bullet.instance()
		b.start($Muzzle.global_transform)
		get_node("/root/Game/EnemyBullets").fire(b)
		$Timer.start()
		change_state("shoot_waiting")




func _on_Timer_timeout():
	var c = Scan.get_collider()
	if c != null and c.name == 'Player':
		if state == "waiting":
			change_state("shooting")
		if state == "shoot_waiting":
			change_state("shooting")
	else:
		change_state("searching")
