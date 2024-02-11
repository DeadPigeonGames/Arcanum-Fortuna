class_name ShopTradeSection
extends UITabBase

@export var confirm_trade_data : UIPopupData


func _on_trade_button_button_up():
	call_ui_popup_by_caller(confirm_trade_data)
