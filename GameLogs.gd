extends Label

var game_logs = Resources.game_logs
# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = str("Message: ", game_logs)
	pass
	
