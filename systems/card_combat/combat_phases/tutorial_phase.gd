class_name TutorialPhase
extends CombatPhase

enum PopupType
{
	NONE,
	CLICKABLE,
	SHOW_TOOLTIP,
	PLAY_CARD,
	END_TURN
}

@export var popups : Array[TutorialPopupData]

var tutorial_overlay_path := "res://systems/tutorial/tutorial_overlay.tscn"
var clickable_path := "res://systems/tutorial/tutorial_popup_click.tscn"
var show_tooltip_path := ""
var play_card_path := ""
var end_turn_path := ""

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
		var popup_instance : TutorialPopup = create_popup(popups[i].popup_type)
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


func create_popup(popup_type : PopupType):
	var template = get_popup_by_type(popup_type)
	var instance = template.instantiate()
	tutorial_overlay_instance.add_child(instance)
	
	return instance


func get_popup_by_type(popupType : PopupType):
	var path
	
	match popupType:
		PopupType.NONE:
			push_error("ERROR: NO POPUP TYPE SELECTED!")
		PopupType.CLICKABLE:
			path = clickable_path
		PopupType.SHOW_TOOLTIP:
			path = show_tooltip_path
		PopupType.PLAY_CARD:
			path = play_card_path
		PopupType.END_TURN:
			path = end_turn_path
	
	return load(path)
