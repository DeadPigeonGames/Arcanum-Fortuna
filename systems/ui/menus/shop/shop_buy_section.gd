class_name ShopBuySection
extends UITabBase

@export var confirm_pay_data : UIPopupData


func _on_pay_button_button_up():
	call_ui_popup_by_caller(confirm_pay_data)
