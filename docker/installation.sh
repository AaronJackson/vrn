#!/bin/bash

echo "BUILDING IMAGE" 

echo "PULLING UPDATES"
apt-get update
echo "INSTALLING UPDATES"
apt-get upgrade -y
echo "INSTALLING TOOLS"
#note: DO NOT INSTALL NUMPY OR MATPLOTLIB WITH PIP it doesn't work for some reaons and will be annoying to debug
apt-get install -y git vim sudo wget man gawk libgoogle-glog-dev libboost-all-dev python-numpy python-matplotlib cmake build-essential
echo "INSTALLING PIP"
mkdir -p ~/pip/
wget -O ~/pip/install.py https://bootstrap.pypa.io/get-pip.py
python ~/pip/install.py
rm -r ~/pip
pip install visvis imageio dlib


echo "INSTALLING TORCH"
git clone https://github.com/torch/distro.git ~/torch --recursive
cd ~/torch; bash install-deps;
./install.sh
source install/bin/torch-activate

echo "INSTALLING LUA DEPENDENCIES"
git clone https://github.com/1adrianb/thpp.git ~/thpp
cd ~/thpp/thpp
THPP_NOFB=1 ./build.sh

git clone https://github.com/facebook/fblualib.git ~/fblualib
cd ~/fblualib/fblualib/python
luarocks make rockspec/*

echo "INSTALLING VRN"
git clone --recursive https://github.com/AaronJackson/vrn.git ~/vrn
cd ~/vrn
./download.sh





#Everything should be doable by the default user (fuck security amiright)
#Installation is done by root for convenience
#Give the `ubuntu` user ownership and permissions to everything installed
#chown -R ubuntu /home/ubuntu /usr
#chmod -R u+wrx /home/ubuntu /usr
