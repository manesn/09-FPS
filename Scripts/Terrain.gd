extends Spatial

var Tree = preload("res://Scenes/tree_pineSmall_square1.tscn")
onready var Terrain = get_node("/root/Game/Terrain")
onready var Player = get_node("/root/Game/Player")
onready var Key = get_node("/root/Game/Items/Key")
onready var Crate = get_node("/root/Game/Items/Crate")
onready var Enemy = get_node("/root/Game/Enemies/Tank")

func _ready():
	for x in range(-100,100):
		for z in range(-100,100):
			if x % 2 == 0 and z % 2 == 0 and randf() < 0.3:
				var display = true
				if (x < Player.translation.x + 1 and x > Player.translation.x-1) and (z < Player.translation.z + 1 and z > Player.translation.z -1):
					display = false
				if (x < Key.translation.x + 1 and x > Key.translation.x-1) and (z < Key.translation.z + 1 and z > Key.translation.z-1):
					display = false
				if (x < Crate.translation.x + 1 and x > Crate.translation.x-1) and (z < Crate.translation.z + 1 and z > Crate.translation.z-1):
					display = false
				if (x < Enemy.translation.x + 1 and x > Enemy.translation.x-1) and (z < Enemy.translation.z + 1 and z > Enemy.translation.z-1):
					display = false
				if display:
					var t = Tree.instance()
					t.translation = Vector3(x, 0, z)
					var r = randf()*6.28
					t.rotate_y(r)
					var s = 2 + randf()
					t.scale = Vector3(s,s,s)
					Terrain.add_child(t)
