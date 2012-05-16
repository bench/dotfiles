#!/bin/sh

# dotfiles

link_file() {
  source="${PWD}/$1"
  target="${HOME}/${1/_/.}"

  if [ -e $target ] ; then
    if [ ! -d $target ] ; then
      mv $target $target.bak
      ln -sf ${source} ${target}
    fi
  else
    ln -sf ${source} ${target}
  fi
}

for i in _*
do
  link_file $i
done
link_file bin

git submodule sync
git submodule init
git submodule update


# vim

if [ ! -e _vim/bundle/vundle ] ; then
  vim -c "BundleInstall!"
fi

cd _vim/bundle/vimproc
case $OSTYPE in
darwin*)
  sofile="autoload/vimproc_mac.so"
  makefile="make_mac.mak"
  ;;
linux*)
  sofile="autoload/vimproc_unix.so"
  makefile="make_unix.mak"
  ;;
esac
if [ ! -e $sofile ] ; then
  make -f $makefile
fi
cd $DOTFILES
