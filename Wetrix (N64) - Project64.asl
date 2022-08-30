state("Project64") {}

init {
	vars.watcher = new MemoryWatcher<uint>((IntPtr)0xDFFFF958);
}

update {
	vars.watcher.Update(game);
	vars.score = vars.watcher.Current;
}

split {
	return vars.score >= 100000;
}

start {
	return vars.score == 0;
}

reset {
	return vars.score == 4294770684;
}