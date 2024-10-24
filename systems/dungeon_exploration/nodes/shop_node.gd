@tool
class_name ShopNode
extends EventNode

func _trigger_event():
	var shop = SceneHandler.add_ui_element("res://systems/ui/menus/shop/shop.tscn") as Shop
	shop.init(UIBase.UICLayerIndex.GAME_ELEMENT, self)
	shop.setup()
	SfxBg._playTrack(SfxBg.MapTypes.SHOP)
	await shop.shop_closed
