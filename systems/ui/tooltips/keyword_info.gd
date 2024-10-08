class_name KeywordInfo
extends Control

func setup(title: String, description: String, icon: Texture2D):
	%title.text = str("[b]", title, "[/b]")
	%description.text = description
	%icon.texture = icon
