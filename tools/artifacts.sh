cp *.conf build

cd build
rm -rf ttf otf woff woff2 *.pdf
mkdir ttf otf woff woff2

cp *.ttf ttf
cp *.otf otf
cp *.woff woff
cp *.woff2 woff2

tar cvf ${CI_PROJECT_NAME}-${CI_COMMIT_TAG}.tar.gz *.conf ttf otf
sha256sum ${CI_PROJECT_NAME}-${CI_COMMIT_TAG}.tar.gz > ${CI_PROJECT_NAME}-${CI_COMMIT_TAG}.tar.gz.sha256
md5sum ${CI_PROJECT_NAME}-${CI_COMMIT_TAG}.tar.gz > ${CI_PROJECT_NAME}-${CI_COMMIT_TAG}.tar.gz.md5

ln -s ${CI_PROJECT_NAME}-${CI_COMMIT_TAG}.tar.gz ./${CI_PROJECT_NAME}_LATEST.tar.gz
ln -s ${CI_PROJECT_NAME}-${CI_COMMIT_TAG}.tar.gz.sha256 ./${CI_PROJECT_NAME}_LATEST.tar.gz.sha256
ln -s ${CI_PROJECT_NAME}-${CI_COMMIT_TAG}.tar.gz.md5 ./${CI_PROJECT_NAME}_LATEST.tar.gz.md5

rm -rf ttf otf woff woff2 *.pdf
rm *.conf
