class_name ShopNode
extends EventNode

func _trigger_event():
	var shop = SceneHandler.add_ui_element("res://systems/ui/menus/shop/shop.tscn") as Shop
	shop.init(0, self)
	shop.setup()
	await shop.shop_closed
