extends Node

var players = {}

var player_choices = {}

var order = 0

var initial_set : bool = false

var is_on_steam_deck: bool = false
var is_online: bool = false
var steam_app_id: int = 480
var steam_id: int = 0
var steam_username: String = ""

var playing : bool = false #False if hiding, true if playing
var granade : bool = false #False if just hiding, true if planning to throw
var sign : String = "-1"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
