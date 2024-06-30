extends Node

var player_order : Array = []

var players = {} # GLOBAL

var order = 0

var initial_set : bool = false

var my_id

# STEAM DATA DO NOT TOUCH
var is_on_steam_deck: bool = false
var is_online: bool = false
var steam_app_id: int = 480
var steam_id: int = 0
var steam_username: String = ""

