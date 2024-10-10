extends EventBase

func _ready():
	$CanvasLayer.set_layer(UIBase.UICLayerIndex.GAME_ELEMENT)
	SceneHandler.current_ui_window = self
	SfxOther._SFX_Win()
	Settings.apply_player_anim_speed($CanvasLayer/AnimationPlayer)


func complete():
	SceneHandler.current_ui_window = null
	queue_free()
	finished.emit()
