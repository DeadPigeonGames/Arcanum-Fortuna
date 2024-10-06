extends EventBase

func _ready():
	$CanvasLayer.set_layer(UIBase.UICLayerIndex.GAME_ELEMENT)
	SceneHandler.current_ui_window = self
	SfxOther._SFX_Win()


func complete():
	SceneHandler.current_ui_window = null
	queue_free()
	finished.emit()
