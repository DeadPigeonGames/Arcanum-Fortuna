class_name UIBase
extends CanvasLayer

var called_by
var is_current_window := false
var current_tab : UITabBase


func _input(event):
	if is_current_window == false:
		return


func init(layer : int, caller):
	self.set_layer(layer + 1)
	called_by = caller
	is_current_window = true


func execute():
	pass


func close_with_result(result):
	if called_by is UIBase:
		called_by.is_current_window = true
		called_by.receive_result(result)
	queue_free()


func close():
	if called_by is UIBase:
		called_by.is_current_window = true
	queue_free()


func call_ui_element(element):
	var called_element = SceneHandler.add_ui_element(element)
	if called_element is UIBase:
		called_element.init(self.get_layer(), self)
		self.is_current_window = false


func receive_result(result):
	push_error("ERROR! No receive_result implementation in UIBase!")


func switch_tab(tab : PackedScene):
	if current_tab:
		current_tab.close()
	var tab_instance = tab.instantiate()
	add_child(tab_instance)
	current_tab = tab_instance
