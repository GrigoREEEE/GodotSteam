extends Node2D

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()
@onready var ms = $MultiplayerSpawner
# Called when the node enters the scene tree for the first time.
func _ready():
	signal_connect()
	open_lobby_list()
	ms.spawn_function = spawn_level
	

func signal_connect():
	peer.lobby_joined.connect(_on_lobby_joined)
	peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	
	"""multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)"""
	
	
func spawn_level(data):
	var a = (load(data) as PackedScene).instantiate()
	return a

func _on_button_pressed():
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	ms.spawn("res://level.tscn")
	send_player_information(GameManager.steam_username, multiplayer.get_unique_id())
	$Button.hide()
	$Lobby_Container/Lobbies.hide()
	$Refresh.hide()
	
func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	send_player_information.rpc_id(1, GameManager.steam_username, multiplayer.get_unique_id())
	$Button.hide()
	$Lobby_Container/Lobbies.hide()
	$Refresh.hide()
	

func _on_lobby_created(connect, id):
	if connect:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName() + "'s Lobby"))
		Steam.setLobbyJoinable(lobby_id, true)
		print(lobby_id)

func _on_lobby_joined():
	print(peer.get_all_lobby_data())
	#send_player_information.rpc_id(1, GameManager.steam_username, multiplayer.get_unique_id())
	send_player_information.rpc_id(1, GameManager.steam_username, multiplayer.get_unique_id())
	pass

func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()


	
func _on_lobby_match_list(lobbies):
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var memb_count = Steam.getNumLobbyMembers(lobby)
		
		var but = Button.new()
		but.set_text(str(lobby_name, "| Player Count: ", memb_count))
		but.set_size(Vector2(100,5))
		but.connect("pressed", Callable(self, "join_lobby").bind(lobby))
		$Lobby_Container/Lobbies.add_child(but)
		


func _on_refresh_pressed():
	if $Lobby_Container/Lobbies.get_child_count() > 0:
		for n in $Lobby_Container/Lobbies.get_children():
			n.queue_free()

@rpc("any_peer")
func send_player_information(name, id):
	if !GameManager.players.has(id):
		GameManager.players[id] = {
			"name" : name,
			"id" : id,
			"score": 0
		}
	
	if multiplayer.is_server():
		for i in GameManager.players:
			send_player_information.rpc(GameManager.players[i].name, i)
