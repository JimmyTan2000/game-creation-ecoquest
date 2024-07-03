extends Area2D

func _on_CrumpledBottle_body_entered(body):
	if body is Player:
		body.collect()
		hide_and_disable()

func hide_and_disable():
	hide()
	disconnect("body_entered", self, "_on_CrumpledBottle_body_entered")
	



