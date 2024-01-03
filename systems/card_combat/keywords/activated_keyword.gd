class_name  ActivatedKeyword
extends Keyword

## Setup combat phases that should trigger this keyword
@export var combat_phase_triggers : Array[CombatPhaseTrigger] = []
## Setup other events that should trigger this keyword
@export_flags("OnKill", "OnKarmaDecrease", "OnActiveCardsChanged") var triggers := 0

@export_category("Animation")
@export var scale_speed = 0.3

func trigger(source, target, params={}):
	await animate(source, target, params)


func animate(source, target: CombatCard, params):
	if icon_node:
		var tween = icon_node.create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_IN)
		tween.set_parallel(true)
		tween.tween_property(icon_node, "scale", Vector2.ONE * 5.0, scale_speed)
		tween.tween_property(icon_node, "global_position", target.global_position + Vector2(164 / 2, 320 / 2), scale_speed)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_parallel(false)
		tween.tween_property(icon_node, "scale", Vector2.ONE, scale_speed)
		tween.set_parallel(true)
		tween.tween_property(icon_node, "global_position", icon_node.global_position, scale_speed)
		tween.play()
		await tween.finished
