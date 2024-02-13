class_name PauseMenu
extends UIBase

@export var options_scene: PackedScene


func setup():
	pass


func close_pause_menu():
	Pause.continue_game()
	close()


func _on_btn_continue_pressed():
	close_pause_menu()


func _on_btn_back_to_menu_pressed():
	Pause.can_pause = false
	SceneHandler.change_scene("res://systems/ui/menus/main_menu/main_menu.tscn")
	close_pause_menu()


func _input(event):
	if event.is_action_released("ui_cancel"):
		close_pause_menu()


func _on_btn_options_pressed():
	call_ui_element(options_scene)
