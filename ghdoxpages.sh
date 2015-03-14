#!/usr/bin/env bash
## \brief Upload doxygen documentation to GitHub pages
## \author Dan Fekete <thefekete@gmail.com>
## \file

# make sure we have a clean tree and index
if git diff --quiet --exit-code && git diff --cached --quiet --exit-code; then
    echo "Working tree and index are clean. Proceeding"
else
    >&2 echo "Working tree or index is dirty, exiting!"
    exit 1
fi
