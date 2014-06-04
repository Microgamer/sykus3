#!/bin/bash -e

cd "$(dirname $0)"

source Versionfile

mkdir -p lib
cd lib

download_lib() {
  ARCHIVE="$3$2.tgz"
  if [ ! -e $ARCHIVE ]; then
    wget -O "$3$2.tgz" "https://github.com/$1/archive/$2.tar.gz" 

    rm -rf tmp
    mkdir tmp
    tar -C tmp -xzf "$3$2.tgz"

    rm -rf $3
    mv tmp/* $3
    rmdir tmp
  fi
}

# GitHub Projects
download_lib "twbs/bootstrap" $BOOTSTRAP_VER "bootstrap"
download_lib "FortAwesome/Font-Awesome" $FONT_AWESOME_VER "font-awesome"
download_lib "leongersen/noUiSlider" $NOUISLIDER_VER "nouislider"
download_lib "lokesh/lightbox2" $LIGHTBOX2_VER "lightbox2" 

# jQuery
JQUERY_FILE="jquery-$JQUERY_VER.js"
if [ ! -e "$JQUERY_FILE" ]; then
  wget "http://code.jquery.com/$JQUERY_FILE"
  rm -f jquery.js
  ln -s $JQUERY_FILE jquery.js
fi

# LESS fix for nouislider + colorbox
ln -sf lightbox.css lightbox2/css/lightbox.less
ln -sf nouislider.fox.css nouislider/nouislider.fox.less

cd ..

