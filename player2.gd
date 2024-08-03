extends CharacterBody2D

const SPEED = 300.0
@onready var cam = $Camera2D

func _ready():
	GameManager.my_id = multiplayer.get_unique_id()
	GameManager.displayed_name = GameManager.steam_username
	cam.enabled = is_multiplayer_authority()
	$Label.text = GameManager.displayed_name

func player_names():
	for _i in GameManager.players:
		GameManager.players[_i]["body"].get_node("Label").text = GameManager.players[_i]["name"]
		
	
@rpc("any_peer")
func send_player_information(name, id):
	print("Sending info - my name is " + str(name) + ", and my unique id is " + str(id))
	if !GameManager.players.has(id):
		GameManager.players[id] = {
			"name" : name,
			"id" : id,
			"score": 0,
			"body": null
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
