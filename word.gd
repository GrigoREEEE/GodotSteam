extends Label

var pressed : bool = false

func _on_word_select_pressed():
	pressed = !pressed
	print("word '" + self.text + "' press status is: " + str(pressed))
	if (pressed):
		$ColorRect.show()
	else:
		$ColorRect.hide()
	print("My size is " + str(self.size) + " and rect size is " + str($ColorRect.size))
