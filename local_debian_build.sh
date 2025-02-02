#!/bin/bash
COLOR=75
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "amd64" ]; then
    ARCH=amd64
fi

# py3-none-any
NAME=selkies-gstreamer
GIT_TAG=$(git describe --tag)
#echo "selkies_gstreamer-${GIT_TAG#v}-py3-none-any.whl"
echo -e "\033[1;38;5;${COLOR}m>>>\033[0m \033[1;38;5;${COLOR}m selkies_gstreamer-${GIT_TAG#v}-py3-none-any.whl\033[0m"

docker build --build-arg PACKAGE_VERSION=${GIT_TAG#v} . -t $NAME
DOCKER_TAG=latest
I=$(set -x; docker images $NAME:$DOCKER_TAG --format "{{.ID}}")
if [ ! -d dist ]; then
    mkdir dist
fi
(set -x; docker run -v $PWD/dist:/dist $I bash -c "cp /opt/pypi/dist/* /dist/")

# selkies-js-interposer
#echo "selkies-js-interposer_${GIT_TAG}_debian12_$ARCH.deb"
echo -e "\033[1;38;5;${COLOR}m>>>\033[0m \033[1;38;5;${COLOR}m selkies-js-interposer_${GIT_TAG}_debian12_$ARCH.deb\033[0m"
cd addons/js-interposer/

if [ ! -f ./build_debian.sh ]; then
	echo "$PWD/build_debian.sh not found"
	exit 1
fi
./build_debian.sh
cd -
ls -1 addons/js-interposer/


# web
#echo "selkies-gstreamer-web_${GIT_TAG}.tar.gz"
echo -e "\033[1;38;5;${COLOR}m>>>\033[0m \033[1;38;5;${COLOR}m selkies-gstreamer-web_${GIT_TAG}.tar.gz\033[0m"
# gpl
#echo "gstreamer-selkies_gpl_${GIT_TAG}_debian12_$ARCH.tar.gz"
echo -e "\033[1;38;5;${COLOR}m>>>\033[0m \033[1;38;5;${COLOR}m gstreamer-selkies_gpl_${GIT_TAG}_debian12_$ARCH.tar.gz\033[0m"
cd dev

if [ ! -f ./build-gstreamer-debian12.sh ]; then
        echo "$PWD/build-gstreamer-debian12.sh not found"
        exit 1
fi

./build-gstreamer-debian12.sh

cd ..
[ "$(ls -A ./addons/gstreamer/dist)" ] && mv addons/gstreamer/dist/* dist/
[ "$(ls -A ./addons/js-interposer/dist)" ] && mv addons/js-interposer/dist/* dist/
ls -1 dist/
