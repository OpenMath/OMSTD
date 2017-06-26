#!/bin/bash


# See if there is a cached version of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
#export PATH=/tmp/texlive/bin/x86_64-cygwin:$PATH

if [ ! -f /tmp/texlive/bin/x86_64-linux/pdflatex ]; then
  # Obtain TeX Live
  wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
  tar -xzf install-tl-unx.tar.gz
  cd install-tl-20*

  # Install a minimal system
  ./install-tl --profile=../support/texlive.profile

tlmgr install collection-fontsrecommended

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

cd ..
fi



# if need latest Update the TL install but add nothing new
# tlmgr update --self --all --no-auto-install
