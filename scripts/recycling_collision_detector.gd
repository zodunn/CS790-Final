extends RigidBody3D

var speed: float = 10.0
var target: Node3D
signal remove
var clean_state: bool = false
signal scoreboard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.freeze = true
	set_clean_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target and speed != 0:
		$"Area3D".monitoring = false
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		global_transform.origin += direction * speed * delta
	else:
		$"Area3D".monitoring = true
		
		
func set_clean_state():
	if self.name == 'paper' or self.name == 'store':
		clean_state = true


func _on_area_3d_area_entered(area: Area3D) -> void:
	var obj_collided_with = area.get_parent_node_3d()
	if obj_collided_with.name == 'washbin':
		if self.name == 'glass' or self.name == 'metal' or self.name == 'plastic':
			$"Sketchfab_Scene".visible = false
			$"Sketchfab_Scene2".visible = true
		clean_state = true
	elif obj_collided_with.name == name and clean_state:
		scoreboard.emit()
		delete()
	else:
		pass


func delete():
	# Emit the signal before freeing the object
	self.queue_free()
