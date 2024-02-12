class_name DeckInMenu
extends UIBase

@export var deck_preview_overlay : PackedScene

var player_data : PlayerData
var card_stack_node : CardStack


func setup():
	super.setup()
	set_layer(50)


func setup_player_data(player_data : PlayerData):
	card_stack_node = %CardStack
	self.player_data = player_data
	for card in player_data.cardStack:
		card_stack_node.put_card_in_stack(card)


func _on_button_button_up():
	var deck_preview = SceneHandler.add_ui_element(deck_preview_overlay) as DeckPreviewOverlay
	deck_preview.init(0, self)
	deck_preview.setup()
	deck_preview.setup_player_data(player_data)
