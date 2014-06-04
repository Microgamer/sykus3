#!/bin/bash -e

sudo apt-get install nodejs

if ! [ -e /usr/bin/npm ]; then
  echo "Add nodejs apt repo!"
  exit 1
fi

[ -e /usr/bin/node ] || sudo ln -s nodejs /usr/bin/node

sudo npm install uglify-js jshint less -g
sudo apt-get install -y \
  ruby ruby-bundler build-essential imagemagick pngcrush libyaml-dev

sudo bundle install

