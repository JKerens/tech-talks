param isBreaking bool
param version int

var bumpVersion = incrementVersion(isBreaking, version)

assert versionWasBumped = (bumpVersion == version + 1)

func incrementVersion(isBreaking bool, currentVersion int) int => (isBreaking) ? currentVersion + 1 : currentVersion
