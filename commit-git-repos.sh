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

epaper_idf_commit_git_repo_adafruit() {
  msg="$1"
  git_branch="$2"
  adafruit_ver_branch="$3"
  adafruit_ver_tag="$4"

  cd components/Adafruit-GFX-Component/
  git add .

  git commit -m "$msg" || \
    return $?

  git push -u all $git_branch || \
  git push -u origin $git_branch
  git checkout $adafruit_ver_branch
  git merge $git_branch
  git push -u all $adafruit_ver_branch || \
  git push -u origin $adafruit_ver_branch
  git checkout $git_branch

  if [ ! -z "$adafruit_ver_tag" ]; then
    git tag $adafruit_ver_tag && \
    git push origin $adafruit_ver_tag
  fi

  return 0
}

epaper_idf_commit_git_repo_epaper_idf_component() {
  msg="$1"
  git_branch="$2"
  ver_branch="$3"
  ver_tag="$4"

  cd ../epaper-idf-component/
  git add .

  git commit -m "$msg" || \
    return $?

  git push -u all $git_branch || \
  git push -u origin $git_branch
  git checkout $ver_branch
  git merge $git_branch
  git push -u all $ver_branch || \
  git push -u origin $ver_branch
  git checkout $git_branch

  if [ ! -z "$ver_tag" ]; then
    git tag $ver_tag && \
    git push origin $ver_tag
  fi

  return 0
}

epaper_idf_commit_git_repo_epaper_idf() {
  msg="$1"
  git_branch="$2"
  ver_branch="$3"
  ver_tag="$4"

  cd ../..
  git add .

  git commit -m "$msg" || \
    return $?

  git push -u all $git_branch || \
  git push -u origin $git_branch
  git checkout $ver_branch
  git merge $git_branch
  git push -u all $ver_branch || \
  git push -u origin $ver_branch
  git checkout $git_branch

  if [ ! -z "$ver_tag" ]; then
    git tag $ver_tag && \
    git push origin $ver_tag
  fi

  return 0
}

epaper_idf_commit_git_repos_handle_return() {
  ret=$1

  if [ $ret -ne 0 ]; then
    printf '%b\n' "info: git commit skipped with exit code:\n$ret\n"
  fi

  return 0
}

epaper_idf_commit_git_repos() {
  GIT_REPO_BRANCH=${GIT_REPO_BRANCH:-"master"}
  GIT_REPO_VERSION_BRANCH=${GIT_REPO_VERSION_BRANCH:-"v0.1"}
  GIT_REPO_VERSION_BRANCH_ADAFRUIT=${GIT_REPO_VERSION_BRANCH_ADAFRUIT:-"1.10"}
  GIT_REPO_VERSION_TAG=${GIT_REPO_VERSION_TAG:-""}
  GIT_REPO_VERSION_TAG_ADAFRUIT=${GIT_REPO_VERSION_TAG_ADAFRUIT:-""}
  GIT_REPO_COMMIT_MSG=${GIT_REPO_COMMIT_MSG:-"$@"}

  # Copy the main project README.md file into the 
  # component repo so it's the same on both repos:
  cp README.md components/epaper-idf-component/

  # Build latest version of config site:
  cd components/epaper-idf-component
  ./build-web.sh
  cd ../..

  # Copy sites for GitHub:
  rm -rf docs/
  cp -r public/ docs/
  cd components/epaper-idf-component
  rm -rf docs/
  cp -r public/ docs/
  cd ../..

  epaper_idf_commit_git_repo_adafruit "$GIT_REPO_COMMIT_MSG" "$GIT_REPO_BRANCH" "$GIT_REPO_VERSION_BRANCH_ADAFRUIT" "$GIT_REPO_VERSION_TAG_ADAFRUIT"
  epaper_idf_commit_git_repos_handle_return $?

  epaper_idf_commit_git_repo_epaper_idf_component "$GIT_REPO_COMMIT_MSG" "$GIT_REPO_BRANCH" "$GIT_REPO_VERSION_BRANCH" "$GIT_REPO_VERSION_TAG"
  epaper_idf_commit_git_repos_handle_return $?

  epaper_idf_commit_git_repo_epaper_idf "$GIT_REPO_COMMIT_MSG" "$GIT_REPO_BRANCH" "$GIT_REPO_VERSION_BRANCH" "$GIT_REPO_VERSION_TAG"
  epaper_idf_commit_git_repos_handle_return $?
}

epaper_idf_commit_git_repos $@
