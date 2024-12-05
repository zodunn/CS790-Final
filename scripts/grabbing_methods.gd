extends XROrigin3D

# spindle variables
var left_gripping = null
var right_gripping = null
var grabbed = null
var last_midpoint: Vector3
var initial_vector: Vector3
var initial_rotation: Basis
var initial_distance: float
var initial_scale: Vector3

# basic pointing/grabbing variables
var velocity = Vector3(0, 0, 0)
var last_pos_left = 0.0
var last_pos_right = 0.0
var left_has_obj = false
var right_has_obj = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# spindle code
	var midpoint = Vector3(($"left".global_position + $"right".global_position)/2)
	var left_colliding = $"left/RayCast3D".is_colliding()
	var right_colliding = $"right/RayCast3D".is_colliding()
	
	if (left_colliding and right_colliding) and grabbed == null:
		var left_collider = $"left/RayCast3D".get_collider().get_parent_node_3d()
		var right_collider = $"right/RayCast3D".get_collider().get_parent_node_3d()
		if left_collider.name == right_collider.name:
			if left_gripping and right_gripping:
				print('1')
				grabbed = left_collider
				grabbed.global_position = midpoint
				grabbed.global_transform.basis = Basis.IDENTITY
				initial_vector = $"right".global_position - $"left".global_position
				initial_rotation = grabbed.global_transform.basis
				initial_distance = initial_vector.length()
				initial_scale = grabbed.scale
				$"left/LineRenderer".visible = false
				$"right/LineRenderer".visible = false
				#grabbed.freeze = true
	elif grabbed != null and (left_gripping and right_gripping) and !(left_has_obj or right_has_obj):
		print('2')
		var delta_pos = midpoint - last_midpoint
		grabbed.global_position += delta_pos
		var current_vector = $"right".global_position - $"left".global_position
		var current_distance = current_vector.length()
		var rotation_delta = initial_vector.normalized().cross(current_vector.normalized()).normalized()
		var angle = acos(initial_vector.normalized().dot(current_vector.normalized()))
		var rotation_basis = Basis(rotation_delta, angle)
		grabbed.global_transform.basis = rotation_basis
		var scale_factor = current_distance / initial_distance
		grabbed.scale = initial_scale * scale_factor
	# transition from spindle to right grabbing
	elif grabbed != null and (right_gripping and !left_gripping) and !(left_has_obj or right_has_obj):
		print('3')
		grabbed.global_position = $"right".global_position
		grabbed.scale = initial_scale
		grabbed.global_transform.basis = initial_rotation
		last_pos_right = $"right".global_position
		right_has_obj = true
		$"left/LineRenderer".visible = true
	# transition from spindle to left grabbing
	elif grabbed != null and (!right_gripping and left_gripping) and !(left_has_obj or right_has_obj):
		print('4')
		grabbed.global_position = $"left".global_position
		grabbed.scale = initial_scale
		grabbed.global_transform.basis = initial_rotation
		last_pos_left = $"left".global_position
		left_has_obj = true
		$"right/LineRenderer".visible = true
	#elif !left_gripping and !right_gripping and grabbed != null and initial_scale:
		#print('5')
		#grabbed.scale = initial_scale
		##grabbed.freeze = false
		#grabbed = null
		#$"right/LineRenderer".visible = true
		#$"left/LineRenderer".visible = true
		
	last_midpoint = Vector3(($"left".global_position + $"right".global_position)/2)
	
	# transition from basic pointing/grasping to spindle
	if right_has_obj and left_colliding:
		var collider = $"left/RayCast3D".get_collider().get_parent_node_3d()
		if grabbed == collider and left_gripping:
			print('6')
			right_has_obj = false
			grabbed.global_position = midpoint
			grabbed.global_transform.basis = Basis.IDENTITY
			initial_vector = $"right".global_transform.origin - $"left".global_transform.origin
			initial_rotation = grabbed.global_transform.basis
			initial_distance = initial_vector.length()
			initial_scale = grabbed.scale
			$"left/LineRenderer".visible = false
	if left_has_obj and right_colliding:
		var collider = $"right/RayCast3D".get_collider().get_parent_node_3d()
		if grabbed == collider and right_gripping:
			print('7')
			left_has_obj = false
			grabbed.global_position = midpoint
			grabbed.global_transform.basis = Basis.IDENTITY
			initial_vector = $"right".global_transform.origin - $"left".global_transform.origin
			initial_rotation = grabbed.global_transform.basis
			initial_distance = initial_vector.length()
			initial_scale = grabbed.scale
			$"right/LineRenderer".visible = false
	
	# basic pointing
	if left_colliding and grabbed == null and !right_colliding:
		var collider = $"left/RayCast3D".get_collider().get_parent_node_3d()
		if left_gripping and collider.name:
			print('8')
			grabbed = collider
			#grabbed.freeze = true
			grabbed.global_position = $"left".global_position
			last_pos_left = $"left".global_position
			$"left/LineRenderer".visible = false
			left_has_obj = true
	elif right_colliding and grabbed == null and !left_colliding:
		var collider = $"right/RayCast3D".get_collider().get_parent_node_3d()
		if right_gripping and collider.name:
			print('9')
			grabbed = collider
			#grabbed.freeze = true
			grabbed.global_position = $"right".global_position
			last_pos_right = $"right".global_position
			$"right/LineRenderer".visible = false
			right_has_obj = true
	elif grabbed != null and right_gripping and right_has_obj:
		print('10')
		var delta_pos = $"right".global_position - last_pos_right
		velocity = delta_pos / delta
		grabbed.global_position += delta_pos
		last_pos_right = $"right".global_position
	elif grabbed != null and left_gripping and left_has_obj:
		print('11')
		var delta_pos = $"left".global_position - last_pos_left
		velocity = delta_pos / delta
		grabbed.global_position += delta_pos
		last_pos_left = $"left".global_position
	elif !left_gripping and !right_gripping and grabbed != null:
		print('12')
		#grabbed.freeze = false
		grabbed.linear_velocity = velocity
		grabbed = null
		velocity = Vector3(0, 0, 0)
		$"right/LineRenderer".visible = true
		$"left/LineRenderer".visible = true
		left_has_obj = false
		right_has_obj = false


func _on_right_input_float_changed(name: String, value: float) -> void:
	if name == 'trigger':
		if value > 0:
			right_gripping = true
		else:
			right_gripping = false


func _on_left_input_float_changed(name: String, value: float) -> void:
	if name == 'trigger':
		if value > 0:
			left_gripping = true
		else:
			left_gripping = false
