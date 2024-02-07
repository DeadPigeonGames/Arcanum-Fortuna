class_name TutorialPopupEndturn
extends TutorialPopup

#region override functions

func init(data : TutorialPopupData, combat : CardBattle):
	super.init(data, combat)
	combat.unlock_player_actions()
	combat.player_turn_ended.connect(on_player_turn_ended)


func execute():
	highlight_elements(false)
	await combat.game_board.lock_friendly_cards(combat)
	combat.lock_player_actions()
	completed.emit()


#endregion


func on_player_turn_ended():
	execute()