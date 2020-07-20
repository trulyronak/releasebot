# ReleaseBot

### Functionality

* handles `/release` commands on slack and
	* branches off of `develop` to create `staged-release-version`
	* bumps the version on `staged-release`
	* creates a PR from `staged-release-version` to `release`