class_name ScreenFadeOverlay
extends CanvasLayer

signal fade_in_complete
signal fade_out_complete
signal tint_complete

const BLACK_TRANSPARENT = Color(0, 0, 0, 0)

var tree : SceneTree
var tween : Tween
var tween_trans = Tween.TRANS_LINEAR
var tween_ease = Tween.EASE_IN_OUT
var fade_in_color = BLACK_TRANSPARENT
var fade_out_color = Color.BLACK
var color_rect : ColorRect


func _ready():
	tree = get_tree()
	tween = get_tree().create_tween()
	color_rect = $ColorRect


func set_current_tween_trans(tween_trans : Tween.TransitionType):
	self.tween_trans = tween_trans


func set_current_tween_ease(tween_ease : Tween.EaseType):
	self.tween_ease = tween_ease


func set_fade_in_color(color : Color):
	fade_in_color = color


func set_fade_out_color(color : Color):
	fade_out_color = color


func set_is_mouse_blocked(value : bool):
	if value:
		color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE


func fade_in(duration: float, force_fade : bool = true, block_mouse : bool = false):
	await tree.process_frame
	set_is_mouse_blocked(block_mouse)
	setup_tween_internal()
	if force_fade:
		color_rect.color = Color.BLACK
	tween.tween_property(color_rect, "color", fade_in_color, duration).from_current()
	tween.finished.connect(emit_fade_in_complete_internal)


func fade_out(duration : float, force_fade : bool = true, block_mouse : bool = false):
	await tree.process_frame
	set_is_mouse_blocked(block_mouse)	
	setup_tween_internal()
	if force_fade:
		color_rect.color = BLACK_TRANSPARENT
	tween.tween_property(color_rect, "color", fade_out_color, duration).from_current()
	tween.finished.connect(emit_fade_out_complete_internal)


func restore_default():
	tween_trans = Tween.TRANS_LINEAR
	tween_ease = Tween.EASE_IN_OUT
	fade_in_color = BLACK_TRANSPARENT
	fade_out_color = Color.BLACK
	set_is_mouse_blocked(false)
	setup_tween_internal()


func tint_screen(tint_color : Color, opacity : float, duration : float):
	await tree.process_frame
	opacity = clampf(opacity, 0.0, 1.0)
	tint_color.a = opacity
	setup_tween_internal()
	tween.tween_property(color_rect, "color", tint_color, duration).from_current()
	tween.finished.connect(emit_tint_complete_internal)


func reset_tint(duration : float):
	await tree.process_frame
	var color = BLACK_TRANSPARENT
	setup_tween_internal()
	tween.tween_property(color_rect, "color", color, duration).from_current()
	tween.finished.connect(emit_tint_complete_internal)


func emit_tint_complete_internal():
	tint_complete.emit()
	disconnect_tween_internal


func emit_fade_out_complete_internal():
	fade_out_complete.emit()
	disconnect_tween_internal


func emit_fade_in_complete_internal():
	fade_in_complete.emit()
	disconnect_tween_internal


func disconnect_tween_internal():
	tween.finished.disconnect(emit_tint_complete_internal)
	tween.finished.disconnect(emit_fade_out_complete_internal)
	tween.finished.disconnect(emit_fade_in_complete_internal)


func setup_tween_internal():
	if not tween_trans or not tween_ease:
		push_error("ERROR! tween_trans: ", tween_trans, " tween_ease: ", tween_ease, " one of them is null!")
		return
	tween.set_trans(tween_trans)
	tween.set_ease(tween_ease)
