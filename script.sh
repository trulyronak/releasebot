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
git remote set-url trulyronak https://trulyronak:$GH_PERSONAL_ACCESS_TOKEN@github.com/trulyronak/optic.git
# git push trulyronak releasebot/staged-release-$1
# hub pull-request