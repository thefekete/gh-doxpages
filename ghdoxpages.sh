#!/usr/bin/env bash
## \brief Upload doxygen documentation to GitHub pages
## \author Dan Fekete <thefekete@gmail.com>
## \file
##
## Clones master branch from github into a temp directory and runs doxygen. Once
## all the doxygen docs are created, it checks out gh-pages branch (deletes it if
## it exists on github!), rm's all the files except docs, then pushes to github.
## Finally, it deletes the temp directory.

# exit on first error
set -o errexit
shopt -s extglob

ROOT=$(git rev-parse --show-toplevel)
TEMPDIR="$ROOT/gh-pages-temp"
GH_URL=$(git config remote.origin.url)
BRANCH="master"
#BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

#echo "git repo root is $ROOT"
#echo "temp dir is $TEMPDIR"

git clone --branch=$BRANCH $GH_URL $TEMPDIR
cd $TEMPDIR
doxygen
if git branch -a | grep -q 'remotes.*gh-pages'; then
    git push origin :gh-pages
fi
git checkout --orphan gh-pages
git rm -rf --ignore-unmatch !(html)
rm -rf !(html)
mv html/* ./
rmdir html
git add .
git commit -m "doxygen documentation"
git push origin gh-pages
cd $ROOT
rm -rf $TEMPDIR

# # make sure we have a clean tree and index
# if git diff --quiet --exit-code && git diff --cached --quiet --exit-code; then
#     echo "Working tree and index are clean. Proceeding"
# else
#     >&2 echo "Working tree or index is dirty, exiting!"
#     exit 1
# fi
#
# shopt -s extglob
# doxygen
# if git branch -a | grep -q 'remotes.*gh-pages'; then
#     git push origin :gh-pages
# fi
# if git branch -a | grep -q 'gh-pages'; then
#     git branch -D gh-pages
# fi
# git checkout --orphan gh-pages
# git rm -rf --ignore-unmatch !(html)
# rm -rf !(html)
# mv html/* ./
# rmdir html
# git add .
# git commit -m "doxygen documentation"
# git push origin gh-pages
# git checkout master
# git branch -D gh-pages
