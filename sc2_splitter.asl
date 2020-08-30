state("SupremeCommander2")
{
	bool     load:        0x11A0B60, 0x48, 0x1D8, 0x70, 0x40, 0x24, 0x38; //TODO: Has a lot of pointers. Make sure this is the one.
	string10 levelName:   0x14F44A0, 0x8;
	bool     menu:        0x84A238, 0x26C;
	bool     levelLoaded: 0x11A0B60, 0x48, 0xBEC, 0x68;
	string30 cutsceneId:  0x14F44BC, 0x8;
}

startup {
	vars.levels = new Dictionary<string, int>
        {
            { "SC2_CA_U01", 10 }, { "SC2_CA_U02", 11 }, { "SC2_CA_U03", 12 }, //shift by 10 to avoid accidental 0-1 split where 0 is a failed parse
			{ "SC2_CA_U04", 13 }, { "SC2_CA_U05", 14 }, { "SC2_CA_U06", 15 },
			{ "SC2_CA_I01", 16 }, { "SC2_CA_I02", 17 }, { "SC2_CA_I03", 18 },
			{ "SC2_CA_I04", 19 }, { "SC2_CA_I05", 20 }, { "SC2_CA_I06", 21 },
			{ "SC2_CA_C01", 22 }, { "SC2_CA_C02", 23 }, { "SC2_CA_C03", 24 },
			{ "SC2_CA_C04", 25 }, { "SC2_CA_C05", 26 }, { "SC2_CA_C06", 27 },
			{ "SC2_CA_TUT", -2 },
        };
}

start {
	if (current.levelName != null)
	{
		int currentlvl = 0;
		vars.levels.TryGetValue(current.levelName, out currentlvl);
		return !current.menu && !current.load && current.levelLoaded && old.levelLoaded //1 frame delay avoids accidental start on loading the new level with U01 being the previous one
			&& (currentlvl == 10 || currentlvl == -2);
	}
}

isLoading {
	return current.load;
}

split {
	int currentlvl, prevlvl; 
	if (current.levelName != null && old.levelName != null) {
		vars.levels.TryGetValue(current.levelName, out currentlvl); 
		vars.levels.TryGetValue(old.levelName, out prevlvl);
		if (currentlvl == prevlvl + 1) {
			return true;
		}
	
		if (current.cutsceneId != null) {
			return currentlvl == 27 && current.cutsceneId.StartsWith("C6_NIS_VICTORY_005_CG_0010");
		}
	}
}
