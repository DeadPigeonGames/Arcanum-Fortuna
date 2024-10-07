class_name PlayerKarmaTriggerTutorial
extends TriggerTutorial

@export var required_karma : int

func check_trigger_condition(combat : CardBattle) -> bool:
	if Settings.get_trigger_tutorial(get_class_name()):
		return false
	if combat.player.karma >= required_karma:
		process_tutorial_popups(combat)
		return true
	return false


static func get_class_name():
	return "PlayerKarmaTriggerTutorial"
