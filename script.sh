#!/bin/bash
set -e # exit with nonzero exit code if anything fails

# clone D4P repo and run script
git clone $D4P_REPO
source ./$D4P_REPO/travis/doc-engine-install.sh