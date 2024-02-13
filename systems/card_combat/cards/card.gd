class_name Card extends Control

@export var card_data: CardData
@export var buff_color := Color.GREEN
@export var debuff_color := Color.RED
@export var inspection := preload("res://systems/ui/menus/card_inspection.tscn")


var artwork_texture : Texture2D
var card_name : String
var cost : int
var base_attack : int
var base_health : int
var attack : int : set = set_attack, get = get_attack
var health: int : set = set_health, get = get_health
var keywords : Array[Keyword] = []
var is_hovered := false

var was_preloaded := false
var was_switched := false
var buffs : Array[Buff]

var default_material : Material
var default_keywordslot_atlas : Texture

@onready var card_flip_animation = %CardFlipAnimation


func _ready():
	if card_data != null and !was_preloaded:
		load_from_data(card_data)
	if !was_preloaded:
		setup()


func _input(event: InputEvent):
	if is_hovered and event.is_action_pressed("open_inspection"):
		var new_inspection = inspection.instantiate() as CardInspection
		new_inspection.init(75, self)
		new_inspection.inspection_init(self)
		SceneHandler.add_ui_element(new_inspection)


func set_attack(value):
	attack = value
	%AttackCost.text = str(max(0, attack))
	if attack > base_attack:
		%AttackCost.self_modulate = buff_color
	elif attack < base_attack:
		%AttackCost.self_modulate = debuff_color
	else:
		%AttackCost.self_modulate = Color.WHITE


func get_attack():
	return attack


func set_health(value):
	health = value
	%HealthCost.text = str(health)
	if health > base_health:
		%HealthCost.self_modulate = buff_color
	elif health < base_health:
		%HealthCost.self_modulate = debuff_color
	else:
		%HealthCost.self_modulate = Color.WHITE


func get_health():
	return health


func copy(card : Card):
	card_data = card.card_data.duplicate()
	init(card.artwork_texture, card.card_name, card.cost, card.attack, card.health, card.keywords)


func load_from_data(data: CardData):
	card_data = data.duplicate()
	card_data.owner = self
	init(data.artwork, data.name, data.cost, data.attack, data.health, data.keywords)
	setup()
	was_preloaded = true


func init(artwork_texture, name, cost, attack, health, keywords):
	self.artwork_texture = artwork_texture
	self.card_name = name
	self.cost = cost
	self.attack = attack
	self.health = health
	self.keywords = keywords.duplicate(true)
	if card_data == null:
		card_data = CardData.new()
		card_data.artwork_texture = artwork_texture
		card_data.card_name = name
		card_data.cost = cost
		card_data.attack = attack
		card_data.health = health
		card_data.keywords = keywords
	for keyword in keywords:
		keyword.init()
	if has_node("%ShowCardTooltip"):
		%ShowCardTooltip.init(card_data)
	if card_data.sound_effect:
		$AudioStreamPlayer.stream = card_data.sound_effect

func setup():
	base_attack = attack
	base_health = health
	attack = base_attack
	health = base_health
	%Artwork.texture = artwork_texture
	%KarmaCost.text = str(cost)
	%AttackCost.text = str(attack)
	%HealthCost.text = str(health)
	default_material = %Artwork.material
	default_keywordslot_atlas = card_data.keyword_slot_texture
	
	for slot in %KeyWordSlots.get_children():
		slot.texture.atlas = null
		slot.texture = slot.texture.duplicate()
		slot.texture.atlas = card_data.keyword_slot_texture
	
	var offset = 0
	for i in range(keywords.size()):
		if keywords[i] is SwitchKeyword:
			offset += 1
			continue
		%KeyWordSlots.get_child(i-offset).get_child(0).set_icon(keywords[i])


func update_texts():
	%AttackCost.text = str(attack)
	%HealthCost.text = str(health)

func try_add_buff(buff : Buff) -> bool:
	if buff in buffs:
		return false
	buff.add_stats(self)
	buffs.push_back(buff)
	return true


func try_remove_buff(buff: Buff) -> bool:
	if not buff in buffs:
		return false
	buff.remove_stats(self)
	buffs.erase(buff)
	return true


func modify_keywords(keywords_to_remove: Array[Keyword], keywords_to_add: Array[Keyword] = []):
	for i in range(keywords.size()):
		%KeyWordSlots.get_child(i).get_child(0).set_icon(null)
	for keyword : Keyword in keywords_to_remove:
		if not keyword in keywords:
			push_error("Cannot remove '%s' keywords from '%s' card, as it does not contain it." % [keyword.title, card_name])
			continue
		keywords.erase(keyword)
	for keyword : Keyword in keywords_to_add:
		keyword.init()
		keywords.push_back(keyword)
	var is_disabling_keyword_left = false
	for keyword in keywords:
		if keyword.has_method("is_disabled"):
			set_disabled_overlay_visible(keyword.is_disabled(self))
			is_disabling_keyword_left = true
			return
	if not is_disabling_keyword_left:
		set_disabled_overlay_visible(false)
	
	var offset = 0
	for i in range(keywords.size()):
		if keywords[i] is SwitchKeyword:
			offset += 1
			continue
		%KeyWordSlots.get_child(i-offset).get_child(0).set_icon(keywords[i])
	card_data.keywords = keywords


func set_disabled_overlay_visible(value : bool):
	$Artwork/DisabledOverlay.visible = value


func set_transformed_visuals(shader_material: ShaderMaterial, keyword_slot_atlas : Texture):
	%Artwork.material = shader_material
	%SwitchLabel.visible = true
	%SwitchLabel.text = card_name
	%SwitchFrame.show()
	for slot in %KeyWordSlots.get_children():
		slot.texture.atlas = null
		slot.texture = slot.texture.duplicate()
		slot.texture.atlas = keyword_slot_atlas
	was_switched = true


func set_default_visuals():
	%SwitchFrame.hide()
	%SwitchLabel.visible = false
	%Artwork.material = default_material
	for i in range(%KeyWordSlots.get_child_count()):
		%KeyWordSlots.get_child(i).texture.atlas = default_keywordslot_atlas


func play_animation(animation):
	if $AnimationPlayer.has_animation(animation):
		$AnimationPlayer.play(animation)


func play_cardflip(forward : bool):
	%Artwork.visible = false
	if card_flip_animation == null:
		return
	if forward:
		card_flip_animation.play("card_flip")
	else:
		card_flip_animation.play_backwards("card_flip")


func animate_icon(emission_texture):
	%KeywordParticles.texture = emission_texture
	%KeywordParticles.emitting = true
	await %KeywordParticles.finished


func _on_mouse_entered():
	is_hovered = true


func _on_mouse_exited():
	is_hovered = false
