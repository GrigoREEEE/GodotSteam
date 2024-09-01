extends Node

var player_name : String

# Called when the node enters the scene tree for the first time.
func _ready():
	player_name = GameManager.steam_username
	print(GameManager.players)
	GameManager.my_id = multiplayer.get_unique_id()
	if (multiplayer.get_unique_id() == 1):
		send_player_information(GameManager.steam_username,multiplayer.get_unique_id(),1)
	else:
		send_player_information.rpc_id(1,GameManager.steam_username,multiplayer.get_unique_id(),1)

@rpc("any_peer")
func send_player_information(name, id, state):
	print("Players")
	print("Sending info - my name is " + str(name) + ", and my unique id is " + str(id))
	if !GameManager.players.has(id):
		print("The id is not found!")
		GameManager.players[id] = {
			"name" : name,
			"id" : id,
		}
	
	if multiplayer.is_server() and state == 1:
		for i in GameManager.players:
			send_player_information.rpc(GameManager.players[i].name, i, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
