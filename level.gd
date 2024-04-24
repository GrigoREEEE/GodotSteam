extends Node


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

func _on_button_pressed():
	print(GameManager.players)


func _on_hide_pressed():
	GameManager.playing = false


func _on_play_pressed():
	GameManager.playing = true


func _on_grab_pressed():
	GameManager.granade = true


func _on_leave_pressed():
	GameManager.granade = false


func _on_rock_pressed():
	GameManager.sign = "rock"


func _on_paper_pressed():
	GameManager.sign = "paper"


func _on_scissors_pressed():
	GameManager.sign = "scissors"
