extends MultiplayerSpawner

@export var player_scene : PackedScene
var players = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = spawn_player
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(remove_player)
		



func spawn_player(data):
	var p = player_scene.instantiate()
	p.set_multiplayer_authority(data)
	print("Uh, oh, my unique ID is: " + str(GameManager.my_id))
	players[data] = p
	return p

func remove_player(data):
	players[data].queue_free()
	players.erase(data)
