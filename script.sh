#!/bin/bash
set -e # exit with nonzero exit code if anything fails

# list to confirm we are on the right repo
echo "Listing Directory"
ls .
git checkout $BRANCH
cd

# clone D4P repo
git clone $D4P_REPO
cd $D4P_DIR
git checkout doc-engine
git pull
git submodule update --init --recursive
bash travis/doc-engine-install.sh
cd

# list to confirm we are on the right repo
echo "Listing Directory"
ls .

echo "Building documentation"
#

echo "Add documentation to repo"
#git add -A

echo "commit"
#git commit -m "Deploy Documentation"


