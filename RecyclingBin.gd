extends Area2D


func _on_RecyclingBin_body_entered(body):
	if body is Player:
		body.check_winning_condition()
