class_name TutorialPopupEndturn
extends TutorialPopup

#region override functions

var old_ui_window

func init(data : TutorialPopupData, combat : CardBattle):
	super.init(data, combat)


func execute():
	super.execute()
	combat.unlock_player_actions()
	old_ui_window = SceneHandler.current_ui_window
	SceneHandler.current_ui_window = self
	combat.player_turn_ended.connect(on_player_turn_ended)


#endregion


func on_player_turn_ended():
	SceneHandler.current_ui_window = old_ui_window
	highlight_elements(false)
	combat.lock_player_actions()
	completed.emit()
