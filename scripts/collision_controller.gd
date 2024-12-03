extends XRController3D

var gripping: bool = false
var holding: bool = false
var obj
var velocity = 0.0
var last_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var start = global_position + (-global_basis.z * 0.1)
	var end = (-global_basis.z * 100) + start
	
	$"LineRenderer".points[0] = start
	$"LineRenderer".points[1] = end
	
	$"RayCast3D".target_position = $"RayCast3D".to_local(end)
	
	var colliding = $"RayCast3D".is_colliding()
	
	if colliding and gripping and not holding:
		obj = $"RayCast3D".get_collider().get_parent_node_3d()
		obj.freeze = true
		obj.global_position = global_position
		holding = true
		last_pos = global_position
		$"LineRenderer".visible = false
	elif holding:
		var delta_pos = global_position - last_pos
		velocity = delta_pos / delta
		obj.global_position += delta_pos
	else:
		if obj:
			obj.freeze = false
			obj.linear_velocity = velocity
			obj = null
			velocity = 0.0
			$"LineRenderer".visible = true
	last_pos = global_position


func _on_input_float_changed(name: String, value: float) -> void:
	if name == 'trigger':
		if value > 0:
			gripping = true
		else:
			gripping = false
			holding = false
