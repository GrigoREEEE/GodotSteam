extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_steam()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Steam.run_callbacks()

func initialize_steam():
	OS.set_environment("SteamAppID",str(480))
	OS.set_environment("SteamGameID",str(480))
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam initialize?: %s" % initialize_response)
	
	if initialize_response['status'] > 0:
		print("Failed to initialize Steam. Shutting down. %s" % initialize_response)
		get_tree().quit()
	
	# Gather additional data
	GameManager.is_on_steam_deck = Steam.isSteamRunningOnSteamDeck()
	GameManager.is_online = Steam.loggedOn()
	GameManager.steam_id = Steam.getSteamID()
	GameManager.steam_username = Steam.getPersonaName()
