class_name DemoLinks
extends Control

const STEAM_WISHLIST_URL := "https://store.steampowered.com/login/?redir=app/2852690"
const GFORMS_URL := "https://forms.gle/T33BMh7h9qJ87tvw7"

func _on_wishlist_button_button_up() -> void:
	OS.shell_open(STEAM_WISHLIST_URL)


func _on_url_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(GFORMS_URL)
