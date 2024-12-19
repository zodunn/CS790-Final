extends Label3D
var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("scoreboard", Callable(self, "_on_score_update"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_score_update():
	score += 1
	text = "Score: " + str(score)
