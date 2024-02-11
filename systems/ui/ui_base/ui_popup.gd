class_name UIPopup
extends UIBase

func on_confirm_button_up():
	super.close_with_result(true)


func on_decline_button_up():
	super.close_with_result(false)
