extends RigidBody3D

var speed: float = 0.0
var target = Vector3(-2.40198, 1, -1.5)
signal remove
var clean_state: bool = false
signal scoreboard
var trash_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.freeze = true
	set_clean_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target and speed != 0:
		$"Area3D".monitoring = false
		global_transform.origin = global_transform.origin.move_toward(target, speed)
	else:
		$"Area3D".monitoring = true
		
		
func set_clean_state():
	if trash_name == 'paper' or trash_name == 'store':
		clean_state = true


func _on_area_3d_area_entered(area: Area3D) -> void:
	print(trash_name)
	var obj_collided_with = area.get_parent_node_3d()
	if obj_collided_with.name == 'washbin':
		if trash_name == 'glass' or trash_name == 'metal' or trash_name == 'plastic':
			$"Sketchfab_Scene".visible = false
			$"Sketchfab_Scene2".visible = true
		clean_state = true
	if obj_collided_with.name == name and clean_state:
		scoreboard.emit()
		delete()
	else:
		pass


func delete():
	# Emit the signal before freeing the object
	remove.emit(self)
	self.queue_free()
