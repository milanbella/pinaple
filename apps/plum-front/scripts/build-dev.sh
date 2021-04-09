set -xe
npm run build
npm run webpack
cp html/*.html ../plum-back/public/
cp -r locales/ ../plum-back/public/
cp -rf assets/* ../plum-back/public/
