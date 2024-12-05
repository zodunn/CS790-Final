extends XRController3D

var gripping: bool = false

# teleport variables
var want_teleport: bool = false
var moving: bool = false
var final_loc: Vector3
var parent: Node3D
var translation_speed: int = 20
var has_let_go: bool = true


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
	
	if $"RayCast3D".is_colliding() and !gripping:
		if want_teleport and has_let_go and moving == false:
			has_let_go = false
			moving = true
			final_loc = $"RayCast3D".get_collision_point()
			parent = get_parent()
			
	if moving:
		parent.global_position = parent.global_position.move_toward(final_loc, delta * translation_speed)
		if parent.global_position == final_loc:
			moving = false


func _on_input_float_changed(name: String, value: float) -> void:
	if name == 'trigger':
		if value > 0:
			gripping = true
		else:
			gripping = false


func _on_button_pressed(name: String) -> void:
	if name == "ax_button":
		want_teleport = true


func _on_button_released(name: String) -> void:
	if name == "ax_button":
		want_teleport = false
		has_let_go = true
