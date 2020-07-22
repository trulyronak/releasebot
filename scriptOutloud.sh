export HUB_EXEC=$(pwd)/hub/bin/hub

rm -rf /tmp/releasebot 
mkdir -p /tmp/releasebot 
cd /tmp/releasebot 
git clone https://github.com/opticdev/optic 
cd optic 
git checkout develop 
git checkout -b releasebot/staged-release-$1 
npm install 
npm run bump $1 
git config --local user.email "tech@useoptic.com" 
git config --local user.name "Release Bot" 
git add -A 
git commit -m "bumped to $1" 
git remote remove origin 
git remote add trulyronak https://github.com/trulyronak/optic  # only for testing
git pull trulyronak  # only for testing
git remote set-url trulyronak https://trulyronak:$GH_PERSONAL_ACCESS_TOKEN@github.com/trulyronak/optic.git  # only for testing
git push trulyronak releasebot/staged-release-$1 
$HUB_EXEC pull-request --no-edit -b release