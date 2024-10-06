class_name ShopPreviewCard
extends SelectCard


func _input(event):
	if is_hovered and event.is_action_pressed("ui_rmb"):
		var new_inspection = inspection.instantiate() as CardInspection
		new_inspection.init(UIBase.UICLayerIndex.GAME_ELEMENT + 5, self)
		new_inspection.setup(self)
		SceneHandler.add_ui_element(new_inspection)
	
	if is_hovered and event.is_action_pressed("ui_lmb"):
		clicked.emit()
		self.selected = not selected
		self.selected_shader.visible = selected
