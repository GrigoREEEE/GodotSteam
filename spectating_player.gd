extends Node

var pn = GameManager.steam_username
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = GameManager.steam_username
	print(GameManager.players)
	GameManager.my_id = multiplayer.get_unique_id()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
