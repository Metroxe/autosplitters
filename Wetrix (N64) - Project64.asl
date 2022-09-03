state("Project64") {}

init {
	vars.watcher = new MemoryWatcher<uint>((IntPtr)0xDFFFF958);
}

startup {
	// The Categories for this game are based around 100k or 1m, so make a setting to switch between
	settings.Add("100k split", true, "Split on 100k points.");
	settings.Add("1m split", true, "Split on 1m points.");
	settings.Add("track lessons", false, "Split on lessons (splits on returning to menu).");
	vars.inMenu = true;
	vars.splitLesson = false;
	vars.oneHundredK = false;
	vars.oneMil = false;
}

update {
	vars.watcher.Update(game);
	vars.splitLesson = false;
	if (vars.watcher.Current == 0) {
		vars.oneHundredK = false;
		vars.oneMil = false;
	}
}

split {
	if (settings["track lessons"]) {

		// used for tracking lesson 8
		if (vars.watcher.Current >= 25000 && vars.watcher.Current < 4294770684) {
			return true;
		}

		if ( vars.watcher.Current == 4294770684 && vars.inMenu == false) {
			vars.inMenu = true;
			return true;
		} else {
			vars.inMenu = vars.watcher.Current == 4294770684;
		}

	} else {

		if (settings["100k split"] && vars.watcher.Current > 100000 && !vars.oneHundredK) {
			vars.oneHundredK = true;
			return true;
		}

		if (settings["1m split"] && vars.watcher.Current > 1000000 && !vars.oneMil) {
			vars.oneMil = true;
			return true;
		}
	}
}

start {
	// since this always starts from the menu, this is how you can indicate starting a run
	if (vars.watcher.Current == 0) {
		if (settings["track lessons"]) {
			vars.inMenu = false;
		}
		return true;
	}
}

reset {
	if (!settings["track lessons"]) {
		// When returning to the menu, the score will be reset to this.
		return vars.watcher.Current == 4294770684;
	}
}