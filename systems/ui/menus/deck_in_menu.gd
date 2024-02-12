class_name DeckInMenu
extends UIBase

@export var deck_preview_overlay : PackedScene

var player_data : PlayerData
var card_stack_node : CardStack
var deck_preview : DeckPreviewOverlay


func _process(delta):
	visible = SceneHandler.combat == null
	# I know this is bad, but Week 10
	# Please do not kill me, I am little good boy,
	# take care of me, need food
	# (will be changed)


func setup():
	super.setup()
	set_layer(1)


func setup_player_data(player_data : PlayerData):
	card_stack_node = %CardStack
	self.player_data = player_data
	for card in player_data.cardStack:
		card_stack_node.put_card_in_stack(card)


func _on_button_button_up():
	if not deck_preview:
		deck_preview = SceneHandler.add_ui_element(deck_preview_overlay) as DeckPreviewOverlay
		deck_preview.init(get_layer(), self)
		deck_preview.setup()
		deck_preview.setup_player_data(player_data)
	else:
		await deck_preview.close()
		deck_preview = null
