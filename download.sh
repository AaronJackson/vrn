#!/bin/bash

echo "This script will download the VRN network model."

wget -O vrn-unguided.t7 \
     http://cs.nott.ac.uk/~psxasj/download.php?file=vrn-unguided.t7
wget -O face-alignment/2D-FAN-300W.t7 \
     https://www.adrianbulat.com/downloads/FaceAlignment/2D-FAN-300W.t7
