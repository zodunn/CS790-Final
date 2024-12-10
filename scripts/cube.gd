extends Area3D

var speed: float = 10.0
var target: Node3D
signal remove

func _process(delta: float) -> void:
	if target:
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		global_transform.origin += direction * speed * delta
		
		if global_transform.origin.distance_to(target.global_transform.origin) < 0.1:
			queue_free()
			
func _on_mouse_entered():
	# Called when the mouse hovers over the cube
	print("testing")
	delete()

func delete():
	# Emit the signal before freeing the object
	remove.emit(self)
	self.queue_free()
