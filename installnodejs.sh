#From https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#debian-lmde
#With minor changes (srsly sudo?)


su -c "apt-get update && apt-get upgrade" root
su -c "apt-get install python g++ make checkinstall fakeroot" root
src=$(mktemp -d) && cd $src
wget -N http://nodejs.org/dist/node-latest.tar.gz
tar xzvf node-latest.tar.gz && cd node-v*
./configure
fakeroot checkinstall -y --install=no --pkgversion $(echo $(pwd) | sed -n -re's/.+node-v(.+)$/\1/p') make -j$(($(nproc)+1)) install
su -c "dpkg -i node_*" root



