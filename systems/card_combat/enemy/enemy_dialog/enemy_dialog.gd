@tool
class_name EnemyDialog
extends Resource


enum TriggerType
{
	NONE = 0,
	ENEMY_CARD = 10,
	ENEMY_HP = 30,
	PLAYER_HP = 40,
	KEYCARD_ATTACK = 50,
	ENEMY_DEATH = 60,
	PLAYER_DEATH = 70
}

@export_multiline var dialogue_lines : String
@export var character_image : Texture2D
@export var sound_effect : AudioStream

@export_category("Trigger Type")
@export var trigger_type : TriggerType:
	set(value):
		trigger_type = value
		notify_property_list_changed()
var card_data : CardData
var hp : int


static func trigger_enemy_hp_dialog(combat : CardBattle, owner):
	if combat.is_tutorial:
		return
	var enemy_data : EnemyData = combat.enemy.data
	for dialog : EnemyDialog in enemy_data.get_dialog_data():
		if dialog.get_trigger_type() == EnemyDialog.TriggerType.ENEMY_HP:
			if combat.enemy.health <= dialog.hp:
				var screen = SceneHandler.add_ui_element(BattleDialog.file_path) as BattleDialog
				screen.init(UIBase.UICLayerIndex.BATTLE_DIALOG, owner)
				screen.setup(dialog, enemy_data.title)
				await screen.dialog_finished
				enemy_data.dialog_data.erase(dialog)


static func trigger_card_place_dialog(combat : CardBattle, card : CardData, owner):
	if combat.is_tutorial:
		return
	var enemy_data : EnemyData = combat.enemy.data
	for dialog : EnemyDialog in enemy_data.get_dialog_data():
		if dialog.get_trigger_type() == EnemyDialog.TriggerType.ENEMY_CARD:
			if dialog.card_data.name == card.name:
				var screen = SceneHandler.add_ui_element(BattleDialog.file_path) as BattleDialog
				screen.init(UIBase.UICLayerIndex.BATTLE_DIALOG, owner)
				screen.setup(dialog, enemy_data.title)
				await screen.dialog_finished
				enemy_data.dialog_data.erase(dialog)


static func trigger_keycard_attack_dialog(combat : CardBattle, attacking_card, owner):
	if combat.is_tutorial:
		return
	var enemy_data : EnemyData = combat.enemy.data
	for dialog : EnemyDialog in enemy_data.get_dialog_data():
		if dialog.get_trigger_type() == EnemyDialog.TriggerType.KEYCARD_ATTACK:
			var attack_card_data
			if attacking_card is CombatCard:
				attack_card_data = attacking_card.card_data
			if attacking_card is CardData:
				attack_card_data = attacking_card
			if dialog.card_data.name == attack_card_data.name:
				var screen = SceneHandler.add_ui_element(BattleDialog.file_path) as BattleDialog
				screen.init(UIBase.UICLayerIndex.BATTLE_DIALOG, owner)
				screen.setup(dialog, enemy_data.title)
				await screen.dialog_finished
				enemy_data.dialog_data.erase(dialog)


static func trigger_player_hp_dialog(combat : CardBattle, owner):
	if combat.is_tutorial:
		return
	var enemy_data : EnemyData = combat.enemy.data
	for dialog : EnemyDialog in enemy_data.get_dialog_data():
		if dialog.get_trigger_type() == EnemyDialog.TriggerType.PLAYER_HP:
			if combat.player.health <= dialog.hp:
				var screen = SceneHandler.add_ui_element(BattleDialog.file_path) as BattleDialog
				screen.init(UIBase.UICLayerIndex.BATTLE_DIALOG, owner)
				screen.setup(dialog, enemy_data.title)
				await screen.dialog_finished
				enemy_data.dialog_data.erase(dialog)


static func trigger_death_dialog(combat : CardBattle, target, owner):
	if combat.is_tutorial:
		return
	var enemy_data = combat.enemy.data
	for dialog : EnemyDialog in enemy_data.get_dialog_data():
		var is_player = target is CardPlayer or target is EnemyPlayer
		var condition =\
		dialog.get_trigger_type() == EnemyDialog.TriggerType.PLAYER_DEATH or\
		dialog.get_trigger_type() == EnemyDialog.TriggerType.ENEMY_DEATH
		if is_player and condition:
			var screen = SceneHandler.add_ui_element(BattleDialog.file_path) as BattleDialog
			screen.init(UIBase.UICLayerIndex.BATTLE_DIALOG, owner)
			screen.setup(dialog, enemy_data.title)
			await screen.dialog_finished
			enemy_data.dialog_data.clear()
			break


func get_trigger_type() -> TriggerType:
	return trigger_type


func get_dialog_lines() -> String:
	return dialogue_lines


func get_character_image() -> Texture2D:
	return character_image


func _get_property_list():
	var retval: Array[Dictionary] = []
	
	if trigger_type ==\
	TriggerType.ENEMY_CARD or\
	trigger_type == TriggerType.KEYCARD_ATTACK:
		retval.append({
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "card_data",
		"type": TYPE_OBJECT
		})
	elif trigger_type ==\
	TriggerType.ENEMY_HP or\
	trigger_type == TriggerType.PLAYER_HP:
		retval.append({
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "hp",
		"type": TYPE_INT
		})
	
	return retval
