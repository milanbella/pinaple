set -xe
rm -rf ../plum-back/public
mkdir ../plum-back/public
cp html/*.html ../plum-back/public/
cp -r locales/ ../plum-back/public/
npm run clean
npm run build
npm run webpack
npm run css-build
cp -r assets/* ../plum-back/public/

