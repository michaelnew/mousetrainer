extends Node

enum GameType {
	LINEAR = 1,
	BURST = 2,
}

var gameType = GameType.LINEAR
var bestSpeedLinear = 1.0
var bestSpeedBurst = 2.0

func _ready():
	self.load_game()

func getSpawnCount():
	match self.gameType:
		GameType.LINEAR:
			return 1
		GameType.BURST:
			return 2

func getStartFrequency():
	match self.gameType:
		GameType.LINEAR:
			return 1.0
		GameType.BURST:
			return 2.0

func getBestSpeed():
	match self.gameType:
		GameType.LINEAR:
			return self.bestSpeedLinear
		GameType.BURST:
			return self.bestSpeedBurst

func setBestSpeed(speed):
	match self.gameType:
		GameType.LINEAR:
			self.bestSpeedLinear = speed
		GameType.BURST:
			self.bestSpeedBurst = speed

func save():
	var save_dict = {
		"best_speed_linear" : self.bestSpeedLinear,
		"best_speed_burst" : self.bestSpeedBurst,
	}
	return save_dict

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var data = parse_json(save_game.get_line())
		
		for i in data.keys():
			if i == "best_speed_linear":
				self.bestSpeedLinear = data[i]
			elif i == "best_speed_burst":
				self.bestSpeedBurst = data[i]

	save_game.close()

func save_game():
	print("saving game")
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var data = self.save()
	save_game.store_line(to_json(data))
	save_game.close()

func reset_save_game():
	var dir = Directory.new()
	dir.remove("user://savegame.save")
	self.bestSpeedLinear = 10.0
	self.bestSpeedBurst = 10.0

# could probably move this kind of thing into a constants file
var green = Color(181/255.0, 214/255.0, 61/255.0)
var lightBlue = Color(0.02, 0.671, 0.294)
var darkBlue = Color(0.004, 0.831, 0.271)
var mediumBlue = Color(0.004, 0.282, 0.282)
var yellow = Color(0.051, 0.298, 0.267)
var orange = Color(0.059, 0.345, 0.384)
var lightOrange = Color(0.059, 0.98, 0.894)
var brown = Color(0.047, 0.153, 0.38)
var clear = Color(1,1,1,0)
