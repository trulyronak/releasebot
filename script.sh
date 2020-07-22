export HUB_EXEC=$(pwd)/hub/bin/hub

rm -rf /tmp/releasebot > /dev/null 2>&1
mkdir -p /tmp/releasebot > /dev/null 2>&1
cd /tmp/releasebot > /dev/null 2>&1
git clone https://github.com/opticdev/optic > /dev/null 2>&1
cd optic > /dev/null 2>&1
git checkout develop > /dev/null 2>&1
git checkout -b releasebot/staged-release-$1 > /dev/null 2>&1
npm install > /dev/null 2>&1
npm run bump $1 > /dev/null 2>&1
git config --local user.email "tech@useoptic.com" > /dev/null 2>&1
git config --local user.name "Release Bot" > /dev/null 2>&1
git add -A > /dev/null 2>&1
git commit -m "bumped to $1" > /dev/null 2>&1
git remote remove origin > /dev/null 2>&1
git remote add trulyronak https://github.com/trulyronak/optic > /dev/null 2>&1 # only for testing
git pull trulyronak > /dev/null 2>&1 # only for testing
git remote set-url trulyronak https://trulyronak:$GH_PERSONAL_ACCESS_TOKEN@github.com/trulyronak/optic.git > /dev/null 2>&1 # only for testing
git push trulyronak releasebot/staged-release-$1 > /dev/null 2>&1
$HUB_EXEC pull-request --no-edit -b release