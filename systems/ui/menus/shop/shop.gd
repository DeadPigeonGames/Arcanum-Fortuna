class_name Shop
extends UIBase

signal shop_closed

@export var shop_buy_tab : PackedScene
@export var shop_trade_tab : PackedScene
@export var shop_burn_tab : PackedScene

var last_clicked_tab


func _process(delta):
	last_clicked_tab.grab_focus()


func setup():
	switch_tab(shop_buy_tab)
	last_clicked_tab = %BuySectionButton


func receive_result(result):
	if current_tab is ShopBuySection:
		print("BUY: ", result)
	if current_tab is ShopTradeSection:
		print("TRADE: ", result)
	if current_tab is ShopBurnSection:
		print("BURN: ", result)


func _on_buy_section_button_button_up():
	last_clicked_tab = %BuySectionButton
	switch_tab(shop_buy_tab)


func _on_trade_section_button_button_up():
	last_clicked_tab = %TradeSectionButton
	switch_tab(shop_trade_tab)


func _on_burn_section_button_button_up():
	last_clicked_tab = %BurnSectionButton
	switch_tab(shop_burn_tab)


func _on_leave_shop_button_button_up():
	shop_closed.emit()
	close()
