class_name TutorialPopupInspection
extends TutorialPopup

var card_inspection

func _input(event):
	if event.is_action_pressed("open_inspection"):
		for node in combat.game_board.get_children():
			if node is CardInspection:
				node.inspection_closed.connect(on_inspection_closed)

#region override functions

func init(data : TutorialPopupData, combat : CardBattle):
	super.init(data, combat)


func execute():
	super.execute()
	#if combat.game_board.player.hand


#endregion


func on_inspection_closed():
	highlight_elements(false)
	completed.emit()
	
