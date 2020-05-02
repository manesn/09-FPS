extends RigidBody

func _ready():
	contact_monitor = true
	set_max_contacts_reported(4)

func _physics_process(_delta):
	var bodies = get_colliding_bodies()
	for b in bodies:
		if b.name == "Player" and b.has_key:
			b.update_crate()
			queue_free()
