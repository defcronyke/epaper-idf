#!/bin/bash
#
# epaper-idf
#
# Copyright (c) 2021 Jeremy Carter <jeremy@jeremycarter.ca>
#
# This code is released under the license terms contained in the
# file named LICENSE, which is found in the top-level folder in
# this project. You must agree to follow those license terms,
# otherwise you aren't allowed to copy, distribute, or use any 
# part of this project in any way.

# Clone a newly forked version of the project, and modify it a 
# bit. You should only run this the first time you clone a new
# fork.

GITLAB_USER=${GITLAB_USER:-"defcronyke-fork"}
GIT_REPO_VERSION_BRANCH=${GIT_REPO_VERSION_BRANCH:-"v0.1"}
GIT_REPO_BRANCH=${GIT_REPO_BRANCH:-"master"}

git clone -b $GIT_REPO_BRANCH --recursive git@gitlab.com:$GITLAB_USER/epaper-idf.git; \
cd epaper-idf; \
git remote add upstream https://gitlab.com/defcronyke/epaper-idf.git; \
sed -i "s#https://github.com/defcronyke#git@gitlab.com:$GITLAB_USER#g" .gitmodules; \
sed -i "s@gitlab.com/defcronyke/epaper-idf/badges/master@gitlab.com/$GITLAB_USER/epaper-idf/badges/$GIT_REPO_BRANCH@g" README.md; \
sed -i "s@gitlab.com/defcronyke/epaper-idf/badges/v0.1@gitlab.com/$GITLAB_USER/epaper-idf/badges/$GIT_REPO_VERSION_BRANCH@g" README.md; \
sed -i "s@gitlab.com/defcronyke/epaper-idf/-/pipelines@gitlab.com/$GITLAB_USER/epaper-idf/-/pipelines@g" README.md; \
sed -i "s@gitlab.com/defcronyke/epaper-idf/-/commits/v0.1@gitlab.com/$GITLAB_USER/epaper-idf/-/commits/$GIT_REPO_VERSION_BRANCH@g" README.md; \
cd components/epaper-idf-component; \
git remote set-url origin git@gitlab.com:$GITLAB_USER/epaper-idf-component.git; \
git remote add upstream https://gitlab.com/defcronyke/epaper-idf-component.git; \
git checkout $GIT_REPO_BRANCH; \
cp ../../README.md .; \
cd ../Adafruit-GFX-Component; \
git remote set-url origin git@gitlab.com:$GITLAB_USER/Adafruit-GFX-Component.git; \
git remote add upstream https://gitlab.com/defcronyke/Adafruit-GFX-Component.git; \
git checkout $GIT_REPO_BRANCH; \
cd ../..
