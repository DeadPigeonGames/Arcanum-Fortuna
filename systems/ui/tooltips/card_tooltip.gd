class_name CardTooltip
extends TooltipBase

@export var sigil_info_template: PackedScene = preload("res://systems/ui/tooltips/keyword_info.tscn")

var sigils : Node

func setup(data : CardData):
	sigils = %Sigils
	if data == null:
		push_error("Cannot setup Card Tooltip! CardData is missing!")
		return
	var added_keywords = []
	for keyword in data.keywords:
		#if not keyword.get_script() in added_keywords:
			var keyword_tooltip = sigil_info_template.instantiate()
			keyword_tooltip.setup(keyword.title, \
				keyword.description + keyword.get_dynamic_description(data.owner), keyword.icon)
			sigils.add_child(keyword_tooltip)
			added_keywords.append(keyword.get_script())


func _process(delta):
	move_to_mouse_pos(%NinePatchRect.get_rect())
