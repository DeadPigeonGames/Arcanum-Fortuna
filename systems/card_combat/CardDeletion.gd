extends TextureRect

@export var hover_color := Color.GRAY
@export var is_active := false

var default_color : Color
var is_hovered := false


func _ready():
	default_color = modulate

func _on_card_drag_started():
	set_active()


func _on_card_drag_ended(dragged_card: CombatCard):
	if is_active and is_hovered:
		dragged_card.delete()
	set_inactive()


func set_active():
	if $AnimationPlayer.current_animation == "anim_open_card_delete":
		return
	$AnimationPlayer.play("anim_open_card_delete")


func set_inactive():
	if $AnimationPlayer.current_animation == "anim_close_card_delete":
		return
	$AnimationPlayer.play("anim_close_card_delete")


func _on_mouse_entered():
	is_hovered = true
	if not is_active:
		return
	modulate = hover_color


func _on_mouse_exited():
	modulate = default_color
	is_hovered = false
