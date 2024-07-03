extends Area2D
signal hit

func _on_Hitbox_body_entered(body):
	if body is Player: 
		body.damage()
		
		
