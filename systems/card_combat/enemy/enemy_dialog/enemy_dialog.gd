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

@export_category("Trigger Type")
@export var trigger_type : TriggerType:
	set(value):
		trigger_type = value
		notify_property_list_changed()
var card_data : CardData
var hp : int


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
