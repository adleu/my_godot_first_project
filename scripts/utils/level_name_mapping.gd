var level_name_mapping := {
	"levels": LevelsManager.levels,
	"special" : LevelsManager.special_levels
}

func get_level_from_string(level_type_string):
	return level_name_mapping[level_type_string]
