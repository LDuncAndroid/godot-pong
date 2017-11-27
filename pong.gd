extends Node2D

#Member Variables
var screen_size
var pad_size
var direction = Vector2(1.0, 0.0)

const INITIAL_BALL_SPEED = 200
var ball_speed = INITIAL_BALL_SPEED
const PAD_SPEED = 250

var goal_scored = false
var score_left = 0
var score_right = 0

func _ready():
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	set_process(true)

func _process(delta):
	var ball_pos = get_node("ball").get_pos()
	var left_rect = Rect2(get_node("left").get_pos() - pad_size*0.5, pad_size)
	var right_rect = Rect2(get_node("right").get_pos() - pad_size*0.5, pad_size)
	var score = get_node("score")
	
	ball_pos += direction * ball_speed * delta
	
	# Flip when touching roof or floor
	if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
    	direction.y = -direction.y

	# Flip, change direction and increase speed when touching pads
	if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
    	direction.x = -direction.x
    	direction.y = randf()*2.0 - 1
    	direction = direction.normalized()
    	ball_speed *= 1.1

	if (ball_pos.x < 0):
		score_right+=1
		goal_scored = true
		
	if (ball_pos.x > screen_size.x):
		score_left+=1
		goal_scored = true
		
	if (goal_scored):
		ball_pos = screen_size*0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1, 0)
		goal_scored = false

	score.clear()
	score.add_text(str(score_left) + " " + str(score_right))

	get_node("ball").set_pos(ball_pos)
	
	# Move left pad
	var left_pos = get_node("left").get_pos()

	if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
    	left_pos.y += -PAD_SPEED * delta
	if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
    	left_pos.y += PAD_SPEED * delta

	get_node("left").set_pos(left_pos)

	# Move right pad
	var right_pos = get_node("right").get_pos()

	if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
    	right_pos.y += -PAD_SPEED * delta
	if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
    	right_pos.y += PAD_SPEED * delta

	get_node("right").set_pos(right_pos)