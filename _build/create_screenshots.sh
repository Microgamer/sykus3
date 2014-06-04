#!/bin/bash -e 

RES="1024x768"

cd "$(dirname $0)"

echo "BEFORE you run this:"
echo "1. Start sykus vmenv"
echo "2. Reset demodata"
echo "3. Add and install sykuscli with SNI"
echo "4. Log in as student on sykuscli"
echo "Press enter to continue..."

read DUMMY

rm -rf screenshots/output || true

bundle exec rspec --color -P 'screenshots/**/*_list.rb' screenshots

for IMG in $(find screenshots/output -type f); do
  mv $IMG tmp.step1.png

  convert tmp.step1.png +repage -crop $RES+0+0 +repage tmp.step2.png
  convert tmp.step2.png -splice 20x20 -gravity east -splice 20x0 tmp.step3.png
  convert tmp.step3.png -alpha set -virtual-pixel transparent \
    -channel A -blur 0x10  -level 50%,100% +channel tmp.step4.png
  convert tmp.step4.png +repage -crop $RES+20+20 +repage tmp.step5.png

  pngcrush -force tmp.step5.png $IMG
  rm tmp.step*.png
done

echo "Success."

