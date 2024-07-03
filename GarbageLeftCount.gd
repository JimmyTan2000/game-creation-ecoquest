extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var garbage_left = Resources.garbage_count

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = str("Garbage Left: ", garbage_left)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
