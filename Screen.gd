extends Node2D

var lab_path = load("res://word.tscn")


var word_count : int
var current_last_char = ""


var word : String
var list : Array
var current_box
var current_lab

var box_length : int = 0

var word_size : Vector2
var standard_size : Vector2 = Vector2(770,70)

var possible_words : Array = ["cup", "water", "snake", "snakeman", "9/11"]
var words_assigned : Array = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	word_count = $LineEdit.word_count
	$Word_Count.text = str(word_count)
	$Last_Character.text = current_last_char
	
@rpc("any_peer", "call_local")
func send_player_information(name, id):
	print("Players")
	print("Sending info - my name is " + str(name) + ", and my unique id is " + str(id))
	if !GameManager.players.has(id):
		print("The id is not found!")
		GameManager.players[id] = {
			"name" : name,
			"id" : id,
		}
	
	if multiplayer.is_server():
		for i in GameManager.players:
			if i != multiplayer.get_unique_id():
				send_player_information.rpc(GameManager.players[i].name, i)

func _on_generate_list_pressed():
	var words_count = 3
	while words_count > 0:
		words_assigned.append(possible_words.pick_random())
		possible_words.erase(words_assigned[(3-words_count)])
		words_count -= 1
	print(words_assigned)
	print(possible_words)
	for i in words_assigned:
		var lab = Label.new()
		lab.text = i
		$Word_Box.add_child(lab)
	$Generate_List.hide()
	
func check_words():
	for _i in $Word_Box.get_children():
		if $LineEdit.text.contains(_i.text):
			print("Word '" + _i.text + "' detected!")
			var red = Color(1.0,0.0,0.0,1.0)
			_i.set("theme_override_colors/font_color",red)
			
func create_word(text, is_word):
	var lab = lab_path.instantiate()
	lab.text = text
	lab.set("theme_override_font_sizes/font_size", 32)
	if (!is_word):
		lab.get_node("Word_Select").queue_free()
	return lab

func create_box():
	var box = HBoxContainer.new()
	box.size = standard_size
	current_box = box 
	$Sentence_Box.add_child(current_box)
	
func assign_size(l):
	print("The size assigned to the word " + l.text + " is: " + str(l.size))
	l.get_node("Word_Select").size = l.size
	l.get_node("ColorRect").size = l.size
	print("The button's size is " + str(l.size))
	print("The button size is:" + str(l.get_node("Word_Select").size))
	print("The button size is:" + str(l.get_node("ColorRect").size))

func _on_submit_pressed():
	$Submit.hide()
	$LineEdit.hide()
	word = $LineEdit.text
	list = word.split(" ")
	self.create_box()
	for _i in list:
		var space = create_word(" ", false)
		var lab1 = create_word(_i, true)
		var lab2 = create_word(_i, true)
		current_box.add_child(lab1)
		assign_size(lab1)
		word_size = lab1.size
		box_length += word_size.x
		if box_length > standard_size.x:
			box_length = lab1.size.x
			lab1.queue_free()
			self.create_box()
			current_box.add_child(lab2)
			assign_size(lab2)
		print("Word " + _i + " has size " + str(word_size))
		current_box.add_child(space)


func _on_send_data_pressed():
	send_player_information.rpc_id(1,GameManager.steam_username,multiplayer.get_unique_id())


func _on_printout_pressed():
	print(GameManager.players)
