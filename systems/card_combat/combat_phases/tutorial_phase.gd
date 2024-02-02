class_name TutorialPhase
extends CombatPhase

@export var popups : Array[TutorialPopupData]

var tutorial_overlay_path := "res://systems/tutorial/tutorial_overlay.tscn"

var tutorial_overlay_instance : TutorialOverlay

#region override functions

func init(combat : CardBattle):
	super.init(combat)


static func get_class_name():
	return "Tutorial Phase"


func get_corresponding_trigger() -> CombatPhaseTrigger.SourcePhases:
	return CombatPhaseTrigger.SourcePhases.TUTORIAL_PHASE


func execute():
	GlobalLog.add_entry(get_class_name() + " started.")
	var template = load(tutorial_overlay_path)
	tutorial_overlay_instance = template.instantiate()
	combat.game_board.get_parent().add_child(tutorial_overlay_instance)
	return await process_effect()


func process_effect() -> ExitState:
	tutorial_overlay_instance.fade_background(0.9, 0.2)
	for i in popups.size():
		var popup_instance : TutorialPopup = create_popup(popups[i].popup_path)
		popup_instance.init(popups[i], combat)
		await popup_instance.completed
		popup_instance.queue_free()
	tutorial_overlay_instance.fade_background(0, 0.2)
	await tutorial_overlay_instance.tween.finished
	completed.emit()
	tutorial_overlay_instance.queue_free()
	return ExitState.DEFAULT


func reset():
	pass


#endregion


func create_popup(popup_path : String):
	var popup_template = load(popup_path)
	var instance = popup_template.instantiate()
	tutorial_overlay_instance.add_child(instance)
	
	return instance
