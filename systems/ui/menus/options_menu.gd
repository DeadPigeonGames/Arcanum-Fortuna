class_name OptionsMenu
extends UIBase


func _input(event):
	super._input(event)
	if event.is_action_released("ui_cancel"):
		called_by.close()
		close()


func _on_btn_back_button_up():
	close()
	print("Test")
