extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_reset_point_pressed() -> void:
	var score_label = get_node("/root/WorldEnvironment/scoreboard/Label3D")
	score_label.score = 0
	score_label.text = "Score: 0"
	print("Score reset to 0")
