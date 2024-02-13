class_name Shop
extends UIBase

signal shop_closed

@export var shop_buy_tab : PackedScene
@export var shop_trade_tab : PackedScene
@export var shop_burn_tab : PackedScene

var buy_tab_instance
var trade_tab_instance
var burn_tab_instance

var last_clicked_tab
var player_data : PlayerData


func _process(delta):
	last_clicked_tab.grab_focus()


func setup():
	last_clicked_tab = %BuySectionButton
	player_data = Player.instance.data
	buy_tab_instance = instance_tab(shop_buy_tab)
	buy_tab_instance.visible = false
	trade_tab_instance = instance_tab(shop_trade_tab)
	trade_tab_instance.visible = false
	burn_tab_instance = instance_tab(shop_burn_tab)
	burn_tab_instance.visible = false
	current_tab = buy_tab_instance
	switch_tab_visible(buy_tab_instance)


func instance_tab(tab : PackedScene):
	var tab_instance = tab.instantiate() as UITabBase
	tab_instance.init(self)
	tab_instance.setup()
	add_child(tab_instance)
	
	return tab_instance


func receive_result(result):
	if current_tab is ShopBuySection:
		print("BUY: ", result)
		#process_buy(result)
	if current_tab is ShopTradeSection:
		print("TRADE: ", result)
	if current_tab is ShopBurnSection:
		print("BURN: ", result)


func _on_buy_section_button_button_up():
	last_clicked_tab = %BuySectionButton
	super.switch_tab_visible(buy_tab_instance)


func _on_trade_section_button_button_up():
	last_clicked_tab = %TradeSectionButton
	super.switch_tab_visible(trade_tab_instance)


func _on_burn_section_button_button_up():
	last_clicked_tab = %BurnSectionButton
	super.switch_tab_visible(burn_tab_instance)


func _on_leave_shop_button_button_up():
	shop_closed.emit()
	close()
