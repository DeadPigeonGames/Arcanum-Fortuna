extends EventBase

func _ready():
	Settings.apply_player_anim_speed($CanvasLayer/AnimationPlayer)
	$CanvasLayer/AnimationPlayer.play("victorious")
	$CanvasLayer.set_layer(UIBase.UICLayerIndex.GAME_ELEMENT)
	SceneHandler.current_ui_window = self
	SfxOther._SFX_Win()


func complete():
	SceneHandler.current_ui_window = null
	queue_free()
	finished.emit()
