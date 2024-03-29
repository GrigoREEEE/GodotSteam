extends CharacterBody2D


const SPEED = 300.0
@onready var cam = $Camera2D

func _ready():
	cam.enabled = is_multiplayer_authority()
	await get_tree().create_timer(0.1).timeout
	print(GameManager.players)
	$Label.text = GameManager.players[multiplayer.get_unique_id()].name
	print("My steam id is: " + str(GameManager.steam_id))

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
