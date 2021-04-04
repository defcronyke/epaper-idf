#!/bin/bash

msg="$@"; ver="v0.1"; cd components/epaper-idf-component/; git add .; git commit -m "$msg"; git push; git checkout $ver; git merge master; git push; git checkout master; cd ../..; git add .; git commit -m "$msg"; git push; git checkout $ver; git merge master; git push; git checkout master
