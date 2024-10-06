class_name BoardFullTriggerTutorial
extends TriggerTutorial


func check_trigger_condition(combat : CardBattle) -> bool:
	if Settings.get_trigger_tutorial(get_class_name()):
		return false
	if combat.game_board.get_friendly_cards().size() == 5:
		process_tutorial_popups(combat)
		return true
	return false


func get_class_name():
	return "BoardFullTriggerTutorial"
