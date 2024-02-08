class_name Card extends Control

@export var card_data: CardData

var artwork_texture : Texture2D
var card_name : String
var cost : int
var attack : int : set = set_attack, get = get_attack
var health: int : set = set_health, get = get_health
var keywords : Array[Keyword] = []
var is_hovered := false

var default_material : Material
var default_keywordslot_atlas : Texture

@onready var card_flip_animation = %CardFlipAnimation

func _ready():
	if card_data != null:
		load_from_data(card_data)
	setup()


func set_attack(value):
	attack = value
	%AttackCost.text = str(attack)


func get_attack():
	return attack


func set_health(value):
	health = value
	%HealthCost.text = str(health)


func get_health():
	return health


func copy(card : Card):
	card_data = card.card_data.duplicate()
	init(card.artwork_texture, card.card_name, card.cost, card.attack, card.health, card.keywords)


func load_from_data(data: CardData):
	card_data = data.duplicate()
	card_data.owner = self
	init(data.artwork, data.name, data.cost, data.attack, data.health, data.keywords)


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


func update_texts():
	%AttackCost.text = str(attack)
	%HealthCost.text = str(health)


func setup():
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
	
	for i in range(keywords.size()):
		%KeyWordSlots.get_child(i).get_child(0).set_icon(keywords[i])


func _on_mouse_entered():
	is_hovered = true


func _on_mouse_exited():
	is_hovered = false


func modify_keywords(keywords_to_remove: Array[Keyword], keywords_to_add: Array[Keyword]):
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
	for i in range(keywords.size()):
		%KeyWordSlots.get_child(i).get_child(0).set_icon(keywords[i])
	card_data.keywords = keywords


func set_transformed_visuals(shader_material: ShaderMaterial, keyword_slot_atlas : Texture):
	%Artwork.material = shader_material
	%SwitchFrame/Label.text = card_name
	%SwitchFrame.show()
	for slot in %KeyWordSlots.get_children():
		slot.texture.atlas = null
		slot.texture = slot.texture.duplicate()
		slot.texture.atlas = keyword_slot_atlas


func set_default_visuals():
	%SwitchFrame.hide()
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
	%KeywordParticles.emitting = true
	%KeywordParticles.process_material.emission_point_texture = emission_texture
	await %KeywordParticles.finished
