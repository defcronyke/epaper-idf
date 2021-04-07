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
  adafruit_ver="$1"

  cd components/Adafruit-GFX-Component/
  git add .

  git commit -m "$msg" || \
    return $?

  git push
  git checkout $adafruit_ver
  git merge master
  git push
  git checkout master

  return 0
}

epaper_idf_commit_git_repo_epaper_idf_component() {
  ver="$1"

  cd ../epaper-idf-component/
  git add .

  git commit -m "$msg" || \
    return $?

  git push
  git checkout $ver
  git merge master
  git push
  git checkout master

  return 0
}

epaper_idf_commit_git_repo_epaper_idf() {
  ver="$1"

  cd ../..
  git add .

  git commit -m "$msg" || \
    return $?

  git push
  git checkout $ver
  git merge master
  git push
  git checkout master

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
  msg="$@"
  ver="v0.1"
  adafruit_ver="1.10"

  epaper_idf_commit_git_repo_adafruit "$adafruit_ver"
  epaper_idf_commit_git_repos_handle_return $?

  epaper_idf_commit_git_repo_epaper_idf_component "$ver"
  epaper_idf_commit_git_repos_handle_return $?

  epaper_idf_commit_git_repo_epaper_idf "$ver"
  epaper_idf_commit_git_repos_handle_return $?
}

epaper_idf_commit_git_repos $@
