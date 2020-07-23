# ReleaseBot

### Functionality

* handles `/release` commands on slack and
	* branches off of `develop` to create `staged-release-version`
	* bumps the version on `staged-release`
	* creates a PR from `staged-release-version` to `release`


Required `.env` vars

- `GITHUB_USER=` - this is the username of the github account that will be forking / making PRs
- `GITHUB_TOKEN` - this is the personal access token (repo:write) of the github account that will be forking / making PRs