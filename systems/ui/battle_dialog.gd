class_name BattleDialog
extends UIBase


signal dialog_finished

static var file_path = "res://systems/ui/battle_dialog.tscn"

func _process(delta):
	%Background.global_position = Vector2.ZERO


func _input(event):
	if is_current_window == false:
		return
	if event.is_action_released("ui_accept") or event.is_action_pressed("pick_up_card"):
		ScreenFade.reset_tint(0.3)
		await ScreenFade.tint_complete
		dialog_finished.emit()
		close()


func init(layer : int, caller):
	self.set_layer(128)
	called_by = caller
	is_current_window = true


func setup(display_text : String, image : Texture2D):
	visible = false
	ScreenFade.tint_screen(Color.BLACK, 0.9, 0.3)
	await ScreenFade.tint_complete
	%Image.set_texture(image)
	%Text.text = display_text
	visible = true
