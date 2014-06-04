#!/bin/bash -e

cd "$(dirname $0)"

./download_libs.sh

if [ "$1" == "prod" ]; then
  export DEBUG=0
  DSTDIR="dist"
else
  export DEBUG=1
  DSTDIR="dist_debug"
fi

rm -rf $DSTDIR

# JSHint
jshint --show-non-errors js

# HTML 
YAML_FILES="pages/nav.yaml,pages/sitemap.yaml,pages/features.yaml"

echo "version: \"?v=$(date +%s)\"" > time.yaml.tmp
JEKYLL_CONF="-d $DSTDIR --config jekyll.yaml,time.yaml.tmp,$YAML_FILES"
bundle exec jekyll build $JEKYLL_CONF
rm time.yaml.tmp

# HTML minify
if [ $DEBUG -eq 0 ]; then
  for FILE in $(find $DSTDIR -name '*.html' -type f); do
    cat "$FILE" \
      |tr '\n' ' ' \
      |ruby -pe 'gsub /<!--.*?-->/, ""' \
      |sed -e 's/\s\+/ /g' \
      > out.html.tmp
    mv out.html.tmp $FILE
  done
fi

# Dirs
mkdir -p $DSTDIR/res/{img,font}

# Images + Screenshots
cp -r img/* $DSTDIR/res/img
cp img/favicon.ico $DSTDIR
cp -r screenshots/output $DSTDIR/res/screenshots

# CSS
if [ $DEBUG -eq 1 ]; then
  LESS_OPTS=""
else
  LESS_OPTS="-x --yui-compress"
fi
lessc less/main.less $LESS_OPTS > $DSTDIR/res/main.css

# JS
cat js/browser_warning.js > jsbuild.tmp  # must be first to prevent jquery halt
cat lib/jquery.js >> jsbuild.tmp
cat lib/bootstrap/js/{transition,carousel}.js >> jsbuild.tmp
cat lib/nouislider/jquery.nouislider.js >> jsbuild.tmp
cat lib/lightbox2/js/lightbox.js >> jsbuild.tmp

for FILE in $(find js -type f |grep '/[0-9]' |sort); do
  cat "$FILE" >> jsbuild.tmp
done

if [ $DEBUG -eq 1 ]; then
  JS_OPTS="-b --comments all"
else
  JS_OPTS="-m -c"
fi
uglifyjs $JS_OPTS < jsbuild.tmp > $DSTDIR/res/main.js
rm -f jsbuild.tmp

# Fonts
cp lib/font-awesome/font/fontawesome-webfont.* $DSTDIR/res/font
cp -r font/* $DSTDIR/res/font

# Dist
if [ $DEBUG -eq 0 ]; then
  find ../* |grep -v _build |xargs rm -rf
  cp -r dist/* ..
fi


