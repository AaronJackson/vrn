#!/bin/bash

echo "This script will download the VRN network model."

wget -O vrn-unguided.t7 \
     https://asjackson.s3.fr-par.scw.cloud/vrn/vrn-unguided.t7
wget -O face-alignment/2D-FAN-300W.t7 \
     https://asjackson.s3.fr-par.scw.cloud/vrn/2D-FAN-300W.t7
