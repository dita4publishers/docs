#!/bin/bash
set -e # exit with nonzero exit code if anything fails

OUTDIR=OUT
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

bash ./travis/doc-engine-install.sh

travis env list


echo "Building documentation"

ant -f $DITA_DIR/integrator.xml
ant -f $DITA_DIR/build.xml -Dargs.input=$TRAVIS_BUILD_DIR/$WEBSITE_DOC_MAP -Doutput.dir=~/$OUTDIR -Dtranstype=d4p-html5

echo "Add documentation to repo"
cd ~/$OUTDIR
ls .

echo "commit"
#git commit -m "Deploy Documentation"


