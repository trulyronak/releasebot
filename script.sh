export HUB_EXEC=$(pwd)/hub/bin/hub

rm -rf /tmp/releasebot > /dev/null 2>&1
mkdir -p /tmp/releasebot > /dev/null 2>&1
cd /tmp/releasebot > /dev/null 2>&1
git clone https://github.com/opticdev/optic > /dev/null 2>&1
cd optic > /dev/null 2>&1
git checkout develop > /dev/null 2>&1
git checkout -b releasebot/staged-release-$1 > /dev/null 2>&1
yarn install > /dev/null 2>&1
yarn run bump $1 > /dev/null 2>&1
git config --local user.email "tech@useoptic.com" > /dev/null 2>&1
git config --local user.name "Release Bot" > /dev/null 2>&1
git add -A > /dev/null 2>&1
git commit -m "bumped to $1" > /dev/null 2>&1
# git remote remove origin > /dev/null 2>&1 # only if we don't want PRs on the main optic branch
$HUB_EXEC fork > /dev/null 2>&1 # establish fork
git remote remove $GITHUB_USER > /dev/null 2>&1 # remove fork so we can enable auth for pushing
git remote add $GITHUB_USER https://github.com/$GITHUB_USER/optic > /dev/null 2>&1 # only for testing
git remote set-url $GITHUB_USER https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/optic.git > /dev/null 2>&1 # only for testing
git push $GITHUB_USER releasebot/staged-release-$1 -f > /dev/null 2>&1 # we force to replace the old staged release (in case we added a new pr)
$HUB_EXEC pull-request -m "Release $1" -b release -p