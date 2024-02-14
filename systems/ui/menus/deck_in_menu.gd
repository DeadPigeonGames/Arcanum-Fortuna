class_name DeckInMenu
extends UIBase

@export var deck_preview_overlay : PackedScene

var card_stack_node : CardStack
var deck_preview : DeckPreviewOverlay
var player_data

func _process(delta):
	visible = SceneHandler.combat == null
	# I know this is bad, but Week 10
	# Please do not kill me, I am little good boy,
	# take care of me, need food
	# (will be changed)
	if card_stack_node != null:
		card_stack_node.update_text()


func setup():
	super.setup()
	await get_tree().process_frame
	player_data = Player.instance.data
	card_stack_node = $Control/Button/CardStack
	card_stack_node.cardStack = player_data.cardStack


func _on_button_button_up():
	if not deck_preview:
		deck_preview = SceneHandler.add_ui_element(deck_preview_overlay) as DeckPreviewOverlay
		deck_preview.init(75, self)
		deck_preview.setup()
	else:
		await deck_preview.close()
		deck_preview = null
