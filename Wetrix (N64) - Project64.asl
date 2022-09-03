state("Project64") {}

init {
	vars.watcher = new MemoryWatcher<uint>((IntPtr)0xDFFFF958);
}

startup {
	// The Categories for this game are based around 100k or 1m, so make a setting to twitch between
	settings.Add("100k", true, "100k = on, 1m = off");
}

update {
	vars.watcher.Update(game);
}

split {
	int target = settings["100k"] ? 100000 : 1000000;
	return vars.watcher.Current >= target;
}

start {
	return vars.watcher.Current == 0;
}

reset {
	return vars.watcher.Current == 4294770684;
}