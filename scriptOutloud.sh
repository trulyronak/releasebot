export HUB_EXEC=$(pwd)/hub/bin/hub

rm -rf /tmp/releasebot 
mkdir -p /tmp/releasebot 
cd /tmp/releasebot 
git clone https://github.com/opticdev/optic 
cd optic 
git checkout develop 
git checkout -b releasebot/staged-release-$1 
yarn install 
yarn run bump $1 
git config --local user.email "tech@useoptic.com" 
git config --local user.name "Release Bot" 
git add -A 
git commit -m "bumped to $1" 
# git remote remove origin  # only if we don't want PRs on the main optic branch
$HUB_EXEC fork  # establish fork
git remote remove $GH_USERNAME  # remove fork so we can enable auth for pushing
git remote add $GH_USERNAME https://github.com/$GH_USERNAME/optic  # only for testing
git pull $GH_USERNAME  # only for testing
git remote set-url $GH_USERNAME https://$GH_USERNAME:$GH_PERSONAL_ACCESS_TOKEN@github.com/$GH_USERNAME/optic.git  # only for testing
git push $GH_USERNAME releasebot/staged-release-$1 
$HUB_EXEC pull-request -m "Release $1" -b release