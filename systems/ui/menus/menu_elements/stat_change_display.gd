class_name StatsChangeDisplay
extends Control


func setup(from : Buff):
	%KeywordLabel.text = %KeywordLabel.text % from.get_creator_name()
	%OwnerLabel.text = %OwnerLabel.text % from.get_owner_name()
	%KeywordIcon.texture = from.created_by.icon
	%AttackChangeLabel.text = ("+" if from.attack_gain >= 0 else "") + str(from.attack_gain)
	%HealthChangeLabel.text = ("+" if from.health_gain >= 0 else "") + str(from.health_gain)
