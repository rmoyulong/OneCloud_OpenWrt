#!/bin/bash

function git_sparse_mo_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../
  cd .. && rm -rf $repodir
}

git_sparse_mo_clone tini https://github.com/hauke/packages utils/tini/patches

cp -rf patches feeds/packages/utils/tini

ls feeds/packages/utils/tini/patches