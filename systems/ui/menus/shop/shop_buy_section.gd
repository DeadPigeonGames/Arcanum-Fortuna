class_name ShopBuySection
extends UITabBase

@export var confirm_pay_data : UIPopupData
@export var shop_card_1 : ShopPreviewCard
@export var shop_card_2 : ShopPreviewCard
@export var shop_card_3 : ShopPreviewCard

var player_data : PlayerData


func _on_pay_button_button_up():
	call_ui_popup_by_caller(confirm_pay_data)
