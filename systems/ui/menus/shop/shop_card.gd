class_name ShopPreviewCard
extends SelectCard


func _input(event):
	if is_hovered and event.is_action_pressed("open_inspection"):
		var new_inspection = inspection.instantiate() as CardInspection
		new_inspection.init(75, self)
		new_inspection.inspection_init(self)
		SceneHandler.add_ui_element(new_inspection)
	
	if is_hovered and event.is_action_pressed("pickUpCard"):
		clicked.emit()
		self.selected = not selected
		self.selected_shader.visible = selected


func animate_burn():
	var artwork = %Artwork
	artwork.material = delete_material
	artwork.material = delete_material
	artwork.material = delete_material
	artwork.material = delete_material
	
	%Cardback.visible = false
	var random_angle = [-1, -0.5, 0.5, 1, 1.5, 2]
	random_angle = random_angle[randi_range(0, random_angle.size() - 1)]
	artwork.material.set_shader_parameter("angle", random_angle)
	var shader_noise : NoiseTexture2D = %Artwork.material.get_shader_parameter("noise")
	shader_noise.noise.seed = randf_range(0.0, 100.0)
	artwork.material.set_shader_parameter("noise", shader_noise)
	play_animation("fade_out_icons")
	var tween = create_tween()
	tween.tween_method(set_shader_value, -1.0, 2.0, death_delay)
	await tween.finished


func set_shader_value(value: float):
	var artwork = %Artwork
	artwork.material.set_shader_parameter("progress", value);
