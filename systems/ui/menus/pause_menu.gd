class_name PauseMenu
extends UIBase

@export var options_scene: PackedScene


func _input(event):
	if event.is_action_released("ui_cancel"):
		close_pause_menu()


func setup():
	pass


func close_pause_menu():
	Pause.continue_game()
	close()


func receive_result(result):
	if result is bool and result == true:
		visible = true


func _on_options_button_button_up():
	visible = false
	call_ui_element(options_scene)


func _on_continue_button_button_up():
	close_pause_menu()


func _on_main_menu_button_button_up():
	Pause.can_pause = false
	SceneHandler.change_scene("res://systems/ui/menus/main_menu/main_menu.tscn")
	close_pause_menu()
