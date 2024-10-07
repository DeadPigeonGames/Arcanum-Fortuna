class_name AccessibilityOptions
extends Control


func reset_tutorials():
	Settings.set_trigger_tutorial(BoardFullTriggerTutorial.get_class_name(), false)
	Settings.set_trigger_tutorial(PlayerKarmaTriggerTutorial.get_class_name(), false)
	Settings.set_trigger_tutorial(SwitchConditionTriggerTutorial.get_class_name(), false)


func _on_texture_button_button_up() -> void:
	reset_tutorials()
