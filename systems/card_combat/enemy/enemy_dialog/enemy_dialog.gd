@tool
class_name EnemyDialog
extends Resource


enum TriggerType
{
	NONE = 0,
	ENEMY_CARD = 10,
	PLAYER_CARD = 20,
	ENEMY_HP = 30,
	PLAYER_HP = 40,
	KEYCARD_ATTACK = 50,
	FINISHING_BLOW = 60
}

@export_multiline var dialogue_lines : Array[String]
@export var character_image : Texture2D

@export_category("Trigger Type")
@export var trigger_type : TriggerType
var card : CardData
var hp : int


func get_trigger_type() -> TriggerType:
	return trigger_type


func get_dialog_lines() -> Array[String]:
	return dialogue_lines


func get_character_image() -> Texture2D:
	return character_image


func _get(prop_name: StringName):
	if prop_name == "trigger_type":
		return trigger_type
	return null


func _set(prop_name: StringName, val) -> bool:
	notify_property_list_changed()
	var retval := false
	print(prop_name)
	if prop_name == "trigger_type":
		print("success")
		trigger_type = val
		retval = true
	
	return retval


func _get_property_list():
	var retval: Array[Dictionary] = []
	
	if trigger_type ==\
	TriggerType.ENEMY_CARD or\
	TriggerType.PLAYER_CARD or\
	TriggerType.KEYCARD_ATTACK:
		retval.append({
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
	 	"usage": PROPERTY_USAGE_NONE,
	 	"name": "CardData",
	 	"type": TYPE_OBJECT
	 	})
	elif trigger_type ==\
	TriggerType.ENEMY_HP or\
	TriggerType.PLAYER_HP:
				retval.append({
		"hint": PROPERTY_HINT_NONE,
	 	"usage": PROPERTY_USAGE_NONE,
	 	"name": "HP",
	 	"type": TYPE_INT
	 	})
	
	#retval.append({
	#	"hint": PROPERTY_HINT_ENUM,
	 #	"usage": PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED,
	 #	"name": "TriggerType",
	 #	"type": TYPE_INT
	 #	})
	
	return retval
