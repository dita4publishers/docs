#!/bin/bash
set -e # exit with nonzero exit code if anything fails

OUTDIR=OUT
HOME_DIR="$(dirname "$TRAVIS_BUILD_DIR")"

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

source ./travis/doc-engine-install.sh

echo "testing env: DITADIR is $DITA_DIR/"

echo "Building documentation"
mkdir $HOME_DIR/$OUTDIR
ant -f $DITA_DIR/integrator.xml
ant -f $DITA_DIR/build.xml -Dargs.input=$TRAVIS_BUILD_DIR/$WEBSITE_DOC_MAP -Doutput.dir=$HOME_DIR/$OUTDIR -Dtranstype=d4p-html5



# clone dir
echo "Cloning repo and adding files to gh-pages branch"
cd 
git clone https://${GH_TOKEN}@${GH_REF}
cd $DOC_DIR
git checkout gh-pages

# copy files
cp -r $HOME_DIR/$OUTDIR/* ./

# inside this git repo we'll pretend to be a new user
echo "git config"
git config user.name "Travis CI"
git config user.email "travis@dita4publishers.com"

# The first and only commit to this new Git repo contains all the
# files present with the commit message "Deploy to GitHub Pages".
echo "add files to repo"
git add -A

echo "commit"
git commit -m "Deploy test"

# Force push from the current repo's master branch to the remote
# repo's gh-pages branch. (All previous history on the gh-pages branch
# will be lost, since we are overwriting it.) We redirect any output to
# /dev/null to hide any sensitive credential data that might otherwise be exposed.
echo "push"
git push  > /dev/null 2>&1


