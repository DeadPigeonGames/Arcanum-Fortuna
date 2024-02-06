class_name TutorialPopupData
extends Resource

enum OffsetType
{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var title : String
@export_multiline var text : String
@export var highlighted_elements : Array[NodePath]
@export var offset_type : OffsetType
@export var distance : float

var popup_path : String
