extends Node3D

@export var object_scenes: Array[PackedScene]
@export var spawn_interval: float = 2.0
@export var object_speed: float = 10.0
@export var spawn_distance: float = 50.0
@export var spawn_line_x: float = -6.0 
@export var min_y: float = -1.0
@export var max_y: float = 3.0

@onready var player = get_parent().get_node("spawnerTarget")

func _ready():
	_start_spawning()

func _start_spawning():
	var spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(Callable(self, "_on_spawn_object"))
	add_child(spawn_timer)
	spawn_timer.start()

func _on_spawn_object():
	if object_scenes.size() == 0:
		return
	var random_scene = object_scenes[randi() % object_scenes.size()]
	var object_instance = random_scene.instantiate()
	print(object_instance)
	print(player.name)
	
	var spawn_y = randf_range(min_y, max_y)
	var spawn_position = player.global_transform.origin + Vector3(spawn_line_x, spawn_y, -spawn_distance)

	get_parent().add_child(object_instance)
	object_instance.global_transform.origin = get_parent().get_node("spawner").global_transform.origin

	object_instance.set("speed", object_speed)
	object_instance.set("target", player)
	
