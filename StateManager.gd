extends Node

enum GameType {
	SLOW_PUSH = 1,
	BURST = 2,
}

var gameType = GameType.SLOW_PUSH

func getSpawnCount():
	match self.gameType:
		GameType.SLOW_PUSH:
			return 1
		GameType.BURST:
			return 2

func getStartFrequency():
	match self.gameType:
		GameType.SLOW_PUSH:
			return 1.0
		GameType.BURST:
			return 2.0

func reset_save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.close()

# could probably move this kind of thing into a constants file or something
var green = Color(181/255.0, 214/255.0, 61/255.0)
var lightBlue = Color(0.02, 0.671, 0.294)
var darkBlue = Color(0.004, 0.831, 0.271)
var mediumBlue = Color(0.004, 0.282, 0.282)
var yellow = Color(0.051, 0.298, 0.267)
var orange = Color(0.059, 0.345, 0.384)
var lightOrange = Color(0.059, 0.98, 0.894)
var brown = Color(0.047, 0.153, 0.38)
