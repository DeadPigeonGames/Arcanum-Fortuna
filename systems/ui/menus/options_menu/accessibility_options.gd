class_name AccessibilityOptions
extends Control


func reset_tutorials():
	Settings.set_trigger_tutorial("BoardFullTriggerTutorial", false)
	Settings.set_trigger_tutorial("PlayerKarmaTriggerTutorial", false)
	Settings.set_trigger_tutorial("SwitchConditionTriggerTutorial", false)


func _on_texture_button_button_up() -> void:
	reset_tutorials()
