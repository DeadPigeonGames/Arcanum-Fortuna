class_name SwitchConditionTriggerTutorial
extends TriggerTutorial

var has_awakened = false

func check_trigger_condition(combat : CardBattle) -> bool:
	if Settings.get_trigger_tutorial(get_class_name()):
		return false
	if not combat.card_awakened.is_connected(set_has_awakened):
		combat.card_awakened.connect(set_has_awakened)
	if has_awakened:
		process_tutorial_popups(combat)
		return true
	return false


func set_has_awakened(card : CombatCard):
	has_awakened = true


static func get_class_name():
	return "SwitchConditionTriggerTutorial"
