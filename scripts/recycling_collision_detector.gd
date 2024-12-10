extends RigidBody3D

var speed: float = 10.0
var target: Node3D
signal remove
var clean_state: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target:
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		global_transform.origin += direction * speed * delta
		
		if global_transform.origin.distance_to(target.global_transform.origin) < 0.1:
			queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
	var obj_collided_with = area.get_parent_node_3d()
	if obj_collided_with.name == 'washbin':
		# add code for setting clean state
		clean_state = true
	elif obj_collided_with.name == name and clean_state:
		# add code for collecting points
		delete()
	else:
		pass


func delete():
	# Emit the signal before freeing the object
	remove.emit(self)
	self.queue_free()
