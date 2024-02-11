class_name UIPopup
extends UIBase

func on_confirm_button_up():
	super.close(true)


func on_decline_button_up():
	super.close(false)
