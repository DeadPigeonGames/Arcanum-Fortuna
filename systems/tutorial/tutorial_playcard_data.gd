class_name TutorialPlaycardData
extends TutorialPopupData

@export_node_path("Control") var target_card_slot : NodePath

func _init():
	popup_path = "res://systems/tutorial/tutorial_popup_playcard.tscn"
