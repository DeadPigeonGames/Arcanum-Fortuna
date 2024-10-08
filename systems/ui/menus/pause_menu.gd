class_name PauseMenu
extends UIBase

@export var options_scene: PackedScene
var anim_player : AnimationPlayer

func _ready() -> void:
	anim_player = $PauseMenu/AnimationPlayer
	Settings.apply_player_anim_speed(anim_player)
	anim_player.play("open_pause_menu")
	await anim_player.animation_finished


func _input(event):
	if anim_player.is_playing():
		return
	if event.is_action_released("pause"):
		close_pause_menu()


func setup():
	anim_player = $PauseMenu/AnimationPlayer
	if SceneHandler.get_current_dialogic():
		Dialogic.paused = true


func close_pause_menu():
	anim_player.play("close_pause_menu")
	await anim_player.animation_finished
	if SceneHandler.get_current_dialogic():
		Dialogic.paused = false
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
	Pause.continue_game()
	if SceneHandler.get_current_dialogic():
		Dialogic.end_timeline()
	SceneHandler.set_current_dialogic(null)
	SceneHandler.change_scene("res://systems/ui/menus/main_menu/main_menu.tscn")
	await Settings.save_config()
	close()
