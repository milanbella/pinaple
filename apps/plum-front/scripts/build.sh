set -xe
rm -rf node_modules
rm -f package-lock.json
npm install
rm -rf ../b/public
mkdir ../b/public
cp html/*.html ../b/public/
cp -r locales/ ../b/public/
npm run clean
npm run sync
npm run build
npm run webpack
npm run css-build
cp -r assets/* ../b/public/

