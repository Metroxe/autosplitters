state("Project64") {}

init {
	vars.watcher = new MemoryWatcher<uint>((IntPtr)0xDFFFF958);
}

startup {
	// The Categories for this game are based around 100k or 1m, so make a setting to switch between
	settings.Add("100k", true, "Turn on to split on 100k. Turn off to split on 1m");
	settings.Add("track lessons", false, "Makes the autosplitter split on returning to the menu so you can track lessons. Also disables the reset.");
	vars.inMenu = true;
	vars.splitLesson = false;
}

update {
	vars.watcher.Update(game);
	vars.splitLesson = false;
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
		int target = settings["100k"] ? 100000 : 1000000;
		return vars.watcher.Current >= target;
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