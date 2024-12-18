extends Node3D

@export var object_scenes: Array[PackedScene]
@export var spawn_interval: float = 2.0
@export var object_speed: float = 1.0
@export var spawn_distance: float = 50.0
@export var spawn_line_x: float = -6.0
@export var min_y: float = -1.0
@export var max_y: float = 3.0
@export var max_active_objects: int = 3

@onready var player = get_parent().get_node("spawnerTarget")

var active_objects: Array[Node3D] = []  # Tracks active objects
var spawn_timer: Timer = Timer.new()

func _ready():
	_start_spawning()

func _start_spawning():
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(Callable(self, "_on_spawn_object"))
	add_child(spawn_timer)
	spawn_timer.start()

func _on_spawn_object():
	print(active_objects.size())
	
	if active_objects.size() >= max_active_objects:
		_stop_all_objects()
		spawn_timer.stop()
		return
	
	if object_scenes.size() == 0:
		return

	var random_scene = object_scenes[randi() % object_scenes.size()]
	var object_instance = random_scene.instantiate()
	object_instance.connect("remove", Callable(self, "_on_object_deleted"))

	var spawn_y = randf_range(min_y, max_y)
	var spawn_position = player.global_transform.origin + Vector3(spawn_line_x, spawn_y, -spawn_distance)

	get_parent().add_child(object_instance)
	object_instance.global_transform.origin = get_parent().get_node("spawner").global_transform.origin

	object_instance.set("speed", object_speed)
	object_instance.set("target", player)
	active_objects.append(object_instance)
	print(active_objects)
	

func _on_object_deleted(obj: Node3D):
	active_objects.erase(obj)

	if active_objects.size() < max_active_objects:
		_resume_all_objects()
		if spawn_timer.is_stopped():
			spawn_timer.start()

func _stop_all_objects():
	for obj in active_objects:
		if(obj != null):
			obj.set("speed", 0)

func _resume_all_objects():
	for obj in active_objects:
		if(obj != null):
			obj.set("speed", 1)
