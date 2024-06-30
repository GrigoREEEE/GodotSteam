extends LineEdit

var word_count : int
var previous_char = ""
var previous_text = ""
var char_count : int = 0
var previous_char_count : int = 0

var allowed_characters = "[A-Za-z_ ]"
var allowed_letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N",
"O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h",
"i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1",
"2","3","4","5","6","7","8","9"]
var allowed_numbers = ["0","1","2","3","4","5","6","7","8","9"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_text_changed(new_text):
	previous_char_count = char_count
	char_count = len(new_text)
	var chars = []
	var old_caret_position = self.caret_column
	print("The text is: '" + new_text + "'" )
	if (new_text == ""):
		print("New text is empty!")
		word_count = 0
		previous_text = new_text
		previous_char = ""
	else:
		if previous_char == " " or previous_char == "":
			chars = allowed_letters
		elif previous_char in [".","?","!"]:
			if previous_char_count > char_count:
				chars = allowed_letters
			else:
				chars = []
		elif previous_char == ",":
			if previous_char_count > char_count:
				chars = allowed_letters + ["!","?","."]
			else:
				chars = [" "]
		else:
			chars = allowed_letters + [" "] + ["!","?",".",","] 
			
		
		var last_char = new_text[-1]
		
		print("The last character is '" + last_char + "', and the allowed characters are " + str(chars))
		
		if last_char in chars:
			previous_text = new_text
			previous_char = last_char
		else:
			self.set_text(previous_text)
			caret_column = old_caret_position
		word_count = new_text.countn(" ")
		self.get_parent().check_words()
