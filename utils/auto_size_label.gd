extends Label
class_name AutoSizeLabel

var prop_path = "theme_override_font_sizes/font_size"
var scene_tree : SceneTree
var resize_steps = 1

## only works if is not on clip text or anything

func auto_size():
	await scene_tree.process_frame
	if get_line_count() > get_visible_line_count():
		var font_size = get(prop_path)
		set(prop_path, font_size - resize_steps)
		auto_size()


func set_text_auto_size(text : String, tree : SceneTree, steps : int = 3):
	resize_steps = steps
	scene_tree = tree
	set_text(text)
	auto_size()
