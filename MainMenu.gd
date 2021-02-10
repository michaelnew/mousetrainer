extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player = preload("res://MainScene.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MenuButton_pressed():
	StateManager.gameType = StateManager.GameType.SLOW_PUSH
	get_tree().change_scene_to(player)

func _on_MenuButton2_pressed():
	StateManager.gameType = StateManager.GameType.BURST
	get_tree().change_scene_to(player)

func _on_MenuButton6_pressed():
	StateManager.reset_save_game()
