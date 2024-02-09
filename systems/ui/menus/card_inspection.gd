class_name CardInspection
extends Control

signal inspection_closed

@export var default_icon : Texture
@export var switched_icon : Texture
@export var stat_change_scene : PackedScene
@export var switch_artwork_shader : Material
@export var switch_keyword_slots : Texture

var is_switched := false
var switch_keyword : SwitchKeyword
var switch_buff : Buff

var preview_card : Card


func init(card_to_display: Card):
	preview_card = %PreviewCard
	$SwitchCondition.hide()
	%BaseAttackLabel.text = str(card_to_display.card_data.attack)
	%BaseHealthLabel.text = str(card_to_display.card_data.health)
	var card_data = card_to_display.card_data
	preview_card.load_from_data(card_to_display.card_data)
	preview_card.scale = Vector2(2.56, 2.56)
	
	for buff : Buff in card_to_display.buffs:
		preview_card.try_add_buff(buff)
	preview_card.health = card_to_display.health
	preview_card.attack = card_to_display.attack
	if card_to_display.was_switched:
		preview_card.set_transformed_visuals(switch_artwork_shader, switch_keyword_slots)
	for keyword in preview_card.keywords:
		if keyword is SwitchKeyword:
			switch_keyword = keyword
			switch_buff = Buff.new(switch_keyword.health_difference, \
					switch_keyword.attack_difference, switch_keyword, card_to_display)
			$SwitchCondition.show()
	$CardFlavour/CardFlavourText.text = card_data.description
	update_keyword_labels()
	update_buff_display()

func update_keyword_labels():
	for i in range(4):
		get_node("KeywordDescriptions/VBoxContainer/Label%d" % (i+1)).text = ""
	
	var offset := 0
	for i in range(preview_card.keywords.size()):
		var keyword_label = get_node("KeywordDescriptions/VBoxContainer/Label%d" % (i+1-offset))
		var keyword = preview_card.keywords[i]
		if preview_card.keywords[i] is SwitchKeyword:
			$SwitchCondition/Label.text = "[b]%s -[/b] %s"
			$SwitchCondition/Label.text = $SwitchCondition/Label.text % [keyword.title, keyword.description]
			keyword_label.text = ""
			offset += 1
			continue
		keyword_label.text = "[b]%s -[/b] %s"
		keyword_label.text = keyword_label.text % [keyword.title, keyword.description]


func update_buff_display():
	for stat_change in %CurrentStatChanges.get_children():
		stat_change.free()
	for buff in preview_card.buffs:
		var new_stat_change = stat_change_scene.instantiate()
		new_stat_change.setup(buff)
		%CurrentStatChanges.add_child(new_stat_change)


func _on_close_window_button_button_down():
	inspection_closed.emit()
	queue_free()


func _on_switch_button_button_down():
	if not switch_keyword:
		return
	is_switched = not is_switched
	if is_switched:
		%SwitchButton.icon = switched_icon
		preview_card.modify_keywords(switch_keyword.keywords_to_remove, switch_keyword.keywords_to_gain)
		preview_card.try_add_buff(switch_buff)
		preview_card.set_transformed_visuals(switch_keyword.transformed_artwork_shader, \
				switch_keyword.transformed_keyword_slot_atlas)
	else:
		preview_card.try_remove_buff(switch_buff)
		preview_card.modify_keywords(switch_keyword.keywords_to_gain, switch_keyword.keywords_to_remove)
		%SwitchButton.icon = default_icon
		preview_card.set_default_visuals()
	await get_tree().process_frame
	update_keyword_labels()
	update_buff_display()
