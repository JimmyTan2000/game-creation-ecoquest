extends KinematicBody2D
class_name Player

export(Resource) var moveData

var velocity = Vector2.ZERO
var active = true
var won = false
var game_over = false


onready var animatedSprite = $AnimatedSprite
onready var ladderCheck = $LadderCheck

func start(pos):
	position = pos
	show()

func _ready():
	animatedSprite.frames = load("res://PlayerGreenSkin.tres")
	
	
func damage():
	if active:
		Resources.life -= 1
		get_node("/root/World/CanvasLayer/LifeCounter").text = str("Lives: ",Resources.life)
		$PainSound.volume_db = 10
		if ($PainSound.playing == false):
			$PainSound.play()
		if (Resources.life > 0):
			position.x = 70
			position.y = 0
			start(position)
	#get_tree().reload_current_scene()

func collect():
	if active:
		Resources.garbage_count -= 1
		Resources.point += 1
		get_node("/root/World/CanvasLayer/PointCounter").text = str("Points: ",Resources.point)
		get_node("/root/World/CanvasLayer/GarbageLeftCount").text = str("Garbage Left: ",Resources.garbage_count)
		$CollectionSound.volume_db = -2
		if ($CollectionSound.playing == false):
			$CollectionSound.play()
			
# warning-ignore:unused_argument
func _physics_process(delta):
	game_logging()
	if Input.is_action_pressed("ui_focus_next"):
		restart_game()
		
	if not active:
		return
		
	if is_on_ladder():
		if Input.is_action_pressed("ui_up"):
			velocity.y = -100
		
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x == 0:
		apply_friction()
		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x)
		animatedSprite.animation = "Run"
		animatedSprite.flip_h = input.x > 0

	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			$JumpSound.volume_db = -10
			$JumpSound.play()
			velocity.y = moveData.JUMP_FORCE
	else:
		animatedSprite.animation = "Jump"
		if Input.is_action_just_released("ui_accept") and velocity.y < moveData.JUMP_RELEASE_FORCE:
			velocity.y = moveData.JUMP_RELEASE_FORCE
		
		# Fast falling like Celeste
		if velocity.y > 0:
			velocity.y += moveData.ADDITIONAL_FALL_GRAVITY
		
	var was_in_air = not is_on_floor()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var just_landed = is_on_floor() and was_in_air
	
	if just_landed:
		animatedSprite.animation = "Run"
		animatedSprite.frame = 1
		
	apply_falling_out_of_map_damage()
	
		
	if Resources.life < 1:
		game_over = true
		$GameOverSound.volume_db = 10
		if ($GameOverSound.playing == false):
			$GameOverSound.play()
		hide_and_disable()
			
func is_on_ladder():
	if not ladderCheck.is_colliding(): return false
	var colliding_object = ladderCheck.get_collider()
	if not colliding_object is Ladder: return false
	return true		
				
func apply_gravity():
	velocity.y += moveData.GRAVITY
	velocity.y = min(velocity.y, 300)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION)
	
func hide_and_disable():
	hide()
	active = false
	
func apply_falling_out_of_map_damage():
	if position.y > 500:
		damage()
	
func check_winning_condition():
	if Resources.garbage_count <= 0:
		$WinningSound.volume_db = 15
		if ($WinningSound.playing == false):
			$WinningSound.play()
		won = true
		hide_and_disable()	
	else:
		Resources.game_logs = "You haven't collect all of the garbages in the game. Come back again when you did!"
		
func game_logging():
	if Resources.garbage_count > 0:
		get_node("/root/World/CanvasLayer/GameLogs").text = str("Message: ", Resources.game_logs)
	if Resources.garbage_count <= 0 and Resources.life > 0:
		get_node("/root/World/CanvasLayer/GameLogs").text = str("Message: ", "Go to the recycling bin!")
		if won == true:
			get_node("/root/World/CanvasLayer/GameLogs").text = str("Message: ", "You have won the game! Press Tab to restart.")
	if game_over:
		get_node("/root/World/CanvasLayer/GameLogs").text = str("Message: ", "Game Over!!! Press Tab to restart.")
		
func restart_game():
	Resources.reset()
	get_tree().reload_current_scene()
