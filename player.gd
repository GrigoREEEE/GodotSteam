extends CharacterBody2D


const SPEED = 300.0
@onready var cam = $Camera2D

func _ready():
	cam.enabled = is_multiplayer_authority()
	send_player_information.rpc_id(1, GameManager.steam_username, multiplayer.get_unique_id())
	await get_tree().create_timer(5).timeout
	print(GameManager.players)
	#$Label.text = GameManager.players[multiplayer.get_unique_id()].name
	print("My steam id is: " + str(GameManager.steam_id))
	
@rpc("any_peer")
func send_player_information(name, id):
	print("Sending info - my name is " + str(name) + ", and my unique id is " + str(id))
	if !GameManager.players.has(id):
		GameManager.players[id] = {
			"name" : name,
			"id" : id,
			"score": 0
		}
	
	if multiplayer.is_server():
		for i in GameManager.players:
			send_player_information.rpc(GameManager.players[i].name, i)

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
