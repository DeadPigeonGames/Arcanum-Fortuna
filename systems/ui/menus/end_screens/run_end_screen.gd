class_name RunEndScreen
extends UIBase

const STEAM_WISHLIST_URL := "https://store.steampowered.com/login/?redir=app/2852690"
const GFORMS_URL := "https://forms.gle/T33BMh7h9qJ87tvw7"


func setup():
	return
	if name == "WinScreen":
		SfxOther._SFX_Win()
	else:
		SfxOther._SFX_Loss()
	Pause.can_pause = false


func _ready():
	pass


func _on_retry_button_button_up():
	for node in SceneHandler.ui_container.get_children():
		if node == self:
			continue
		node.queue_free()
	SceneHandler.change_scene("res://systems/ui/menus/main_menu/main_menu.tscn")
	SceneHandler.current_scene.start_game()
	await get_tree().process_frame
	close()


func _on_main_menu_button_button_up():
	for node in SceneHandler.ui_container.get_children():
		if node == self:
			continue
		node.queue_free()
	SceneHandler.change_scene("res://systems/ui/menus/main_menu/main_menu.tscn")
	close()


func _on_wishlist_button_button_up() -> void:
	OS.shell_open(STEAM_WISHLIST_URL)


func _on_url_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(GFORMS_URL)
