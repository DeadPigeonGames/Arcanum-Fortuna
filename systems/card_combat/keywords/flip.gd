class_name Flip
extends ActivatedKeyword

@export_category("Animation")
@export var rotation_duration = 0.8

func init(id = 2):
	super.init(id)


func trigger(source, target, params={}):
	if not target.has_method("flip"):
		push_error("Keyword Flip was triggered from ", source, \
		", but target '", target, "' has no flip method!")
		return
	await super(source, target, params)


func animate(source, target, params={}):
	if not target is Card:
		push_error("Can't animate a non-card!")
		return
	
	var card = target as Card
	var tween = card.create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(card, "scale", Vector2.DOWN, rotation_duration / 2.0)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "scale", Vector2.ONE, rotation_duration / 2.0)
	tween.play()
	await card.get_tree().create_timer(rotation_duration / 2).timeout
	target.flip()
	await card.get_tree().create_timer(rotation_duration / 2).timeout
