extends RigidBody3D

@export var recycling_type: String = 'paper'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	var obj_collided_with = area.get_parent_node_3d()
	if obj_collided_with.name == 'washbin':
		# add code for setting clean state
		pass
	elif obj_collided_with.name == recycling_type:
		# add code for collecting points
		queue_free()
	else:
		pass
