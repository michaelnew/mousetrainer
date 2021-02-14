extends MarginContainer

#preload the player since we're definitely going to use it
var player = preload("res://MainScene.tscn")

func _on_MenuButton_pressed():
	StateManager.gameType = StateManager.GameType.LINEAR
	get_tree().change_scene_to(player)

func _on_MenuButton2_pressed():
	StateManager.gameType = StateManager.GameType.BURST
	get_tree().change_scene_to(player)

func _on_MenuButton6_pressed():
	StateManager.reset_save_game()
