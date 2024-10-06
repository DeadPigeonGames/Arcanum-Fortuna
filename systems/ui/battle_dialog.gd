class_name BattleDialog
extends UIBase


signal dialog_finished

static var file_path = "res://systems/ui/battle_dialog.tscn"

func _process(delta):
	%Background.global_position = Vector2.ZERO


func _input(event):
	if is_current_window == false:
		return
	if visible and\
	(event.is_action_released("ui_accept") or\
	event.is_action_pressed("ui_lmb")):
		visible = false
		ScreenFade.reset_tint(0.3)
		await ScreenFade.tint_complete
		dialog_finished.emit()
		close()


func init(layer : int, caller):
	self.set_layer(128)
	called_by = caller
	set_is_current_window(true)


func setup(dialog : EnemyDialog, character_name):
	visible = false
	ScreenFade.tint_screen(Color.BLACK, 0.9, 0.3)
	await ScreenFade.tint_complete
	%Image.set_texture(dialog.character_image)
	%Text.text = dialog.dialogue_lines
	%Name.text = str("[center]", character_name, "[/center]")
	if dialog.sound_effect:
		$Signature.set_stream(dialog.sound_effect)
		$Signature.play()
	visible = true
