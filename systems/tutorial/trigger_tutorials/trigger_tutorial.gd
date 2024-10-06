class_name TriggerTutorial
extends Resource

signal completed

@export var popups : Array[TutorialPopupData]

var tutorial_overlay_path := "res://systems/tutorial/tutorial_overlay.tscn"
var tutorial_overlay_instance : TutorialOverlay

func call_tutorial_overlay(combat : CardBattle):
	var template = load(tutorial_overlay_path)
	tutorial_overlay_instance = template.instantiate()
	combat.add_child(tutorial_overlay_instance)


func check_trigger_condition(combat : CardBattle) -> bool:
	return false


func process_tutorial_popups(combat):
	call_tutorial_overlay(combat)
	tutorial_overlay_instance.fade_background(0.9, 0.2)
	for i in popups.size():
		var popup_instance : TutorialPopup = create_popup(popups[i].popup_path, tutorial_overlay_instance)
		await popup_instance.init(popups[i], combat)
		popup_instance.execute()
		tutorial_overlay_instance.clickable_rects = popup_instance.clickable_rects
		await popup_instance.completed
		popup_instance.queue_free()
	tutorial_overlay_instance.fade_background(0, 0.2)
	await tutorial_overlay_instance.tween.finished
	completed.emit()
	Settings.set_trigger_tutorial(get_class_name(), true)
	tutorial_overlay_instance.queue_free()


func create_popup(popup_path : String, tutorial_overlay):
	var popup_template = load(popup_path)
	var instance = popup_template.instantiate()
	tutorial_overlay.add_child(instance)
	
	return instance


func get_class_name():
	return "TriggerTutorial"
