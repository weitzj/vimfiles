#!/bin/bash
set -e

cd ~/.vim
rake update
git add -u
git commit -m "submodule update"
rm -rf ~/.vim/bundle
rake


