extends Node


var life = 3
var garbage_count = 12
var point = 0
var game_logs = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset():
	life = 3
	garbage_count = 12
	point = 0
	game_logs = ""

