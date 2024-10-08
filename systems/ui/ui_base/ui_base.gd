class_name UIBase
extends CanvasLayer


enum UICLayerIndex
{
	NONE = 0,
	BATTLE = 1,
	MAIN_MENU = 10,
	GAME_ELEMENT = 40,
	TOOLTIP = 70,
	SCREENFADE = 80,
	BATTLE_DIALOG = 90,
	DIALOGIC = 100,
	PAUSE = 115,
	HIGH_PRIORITY = 120,
	MAX = 128
}


var called_by
var is_current_window := false
var current_tab : UITabBase


func _input(event):
	if is_current_window == false:
		return


func init(layer : int, caller):
	self.set_layer(layer + 1)
	called_by = caller
	set_is_current_window(true)


func close_with_result(result):
	set_is_current_window(false)
	if called_by is UIBase:
		called_by.set_is_current_window(true)
		called_by.receive_result(result)
	if called_by.has_method("receive_result"):
		called_by.receive_result(result)
	queue_free()


func close():
	set_is_current_window(false)
	if called_by != null and called_by is UIBase:
		called_by.set_is_current_window(true)
	queue_free()


func call_ui_element(element):
	var called_element = SceneHandler.add_ui_element(element)
	if called_element is UIBase:
		called_element.init(self.get_layer(), self)
		called_element.setup()
		self.is_current_window = false


func call_ui_popup(popup_data : UIPopupData):
	var called_element = SceneHandler.add_ui_element(popup_data.ui_popup_path)
	if called_element is UIPopup:
		called_element.init(self.get_layer(), self)
		called_element.setup()
		called_element.setup_popup(popup_data)
		self.is_current_window = false


func receive_result(result):
	push_error("ERROR! No receive_result implementation in UIBase!")


func switch_tab(tab : PackedScene):
	if current_tab:
		current_tab.close()
	var tab_instance = tab.instantiate() as UITabBase
	tab_instance.init(self)
	tab_instance.setup()
	add_child(tab_instance)
	current_tab = tab_instance
	
	return tab_instance


func switch_tab_visible(tab):
	current_tab.visible = false
	tab.visible = true
	current_tab = tab


func set_is_current_window(value : bool):
	is_current_window = value
	if value:
		SceneHandler.set_current_ui_window(self)
	else:
		SceneHandler.set_current_ui_window(null)


func show_ui():
	set_is_current_window(true)
	super.show()


func hide_ui():
	set_is_current_window(false)
	super.hide()
