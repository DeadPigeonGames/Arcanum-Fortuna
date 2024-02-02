class_name TutorialPopupData
extends Resource

enum OffsetType
{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var popup_type : TutorialPhase.PopupType
@export var title : String
@export var text : String
@export var highlighted_elements : Array[NodePath]
@export var offset_type : OffsetType
@export var distance : float
