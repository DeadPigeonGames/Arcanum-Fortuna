class_name TutorialExplainPhase
extends CombatPhase

@export var trigger_next : CombatPhaseTrigger.SourcePhases
@export var tutorial_window_name : String

var tutorial_overlay : TutorialOverlay

#region override functions

func init(combat : CardBattle):
	super.init(combat)
	tutorial_overlay = combat.game_board.tutorial_overlay

static func get_class_name():
	return "Tutorial Explain Phase"


func get_corresponding_trigger() -> CombatPhaseTrigger.SourcePhases:
	return CombatPhaseTrigger.SourcePhases.TUTORIAL_PHASE


func process_effect() -> ExitState:
	tutorial_overlay.fade_background(0.5, 0.2)
	tutorial_overlay.show_tutorial()
	await tutorial_overlay.tutorial_window.condition_met
	tutorial_overlay.fade_background(0, 0.2)
	tutorial_overlay.hide_tutorial()
	return ExitState.DEFAULT


func reset():
	pass

#endregion
