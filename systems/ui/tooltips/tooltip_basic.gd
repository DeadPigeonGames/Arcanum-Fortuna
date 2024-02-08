class_name TooltipBasic extends TooltipBase

func setup(title: String, texture: Texture2D, text: String):
	visible = false
	if texture == null:
		%"TooltipIcon".visible = false
	else:
		%"TooltipIcon".texture = texture
	%"TooltipTitle".text = title
	%"TooltipText".text = text
	await SceneHandler.shelf.get_tree().create_timer(0.1).timeout
	visible = true
