class_name TutorialPopupPlaycard
extends TutorialPopup

var target_card_slot : Control
var hand
var player_tiles

#region override functions

func init(data : TutorialPopupData, combat : CardBattle):
	var playcard_data = data as TutorialPlaycardData
	hand = combat.player.hand
	player_tiles = combat.game_board.player_tiles.get_children()
	target_card_slot = combat.get_node(playcard_data.target_card_slot)
	highlighted_elements.append(hand)
	highlighted_elements.append(target_card_slot)
	super.init(data, combat)
	self.highlight_elements(true)
	combat.unlock_player_actions()
	combat.game_board.player.card_drag_ended.connect(on_card_drag_ended)


func execute():
	highlight_elements(false)
	completed.emit()


func highlight_elements(value : bool):
	for node in highlighted_elements:
		node.set_z_index(100 if value else 0)
	
	var color = Color.WHITE
	color.a = 0
	if value:
		color = Color.WHITE_SMOKE
		color.a = 0.15
	target_card_slot.set_self_modulate(color)
	
	for tile in player_tiles:
		if value:
			if tile != target_card_slot:
				tile.add_child(Node.new())
		else:
			tile.remove_child(0)


#endregion

func on_card_drag_ended(card):
	pass
