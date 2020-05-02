extends Control

func _ready():
	pass


func _on_Timer_timeout():
	get_node("/root/Game/HUD/Timer").start()
	visible = false
