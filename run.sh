#!/usr/bin/env bash

# Some values you may adjust
INPUT="examples/"            # Place to find input images
OUTPUT="output/"             # Place to dump raw volumes
VRN_MODEL="vrn-unguided.t7"  # Reconstruction model
CUDA_VISIBLE_DEVICES=0       # GPU number

######################################################################
# The rest of the code
mkdir -p $OUTPUT
mkdir -p $INPUT/scaled

#find $INPUT/scaled -type f -delete
#find $OUTPUT -type f -delete

# We will start by jumping to the face alignment code, processing the
# images to extract the landmarks, and then popping back to the vrn
# code. You might want to remove the /dev/null redirect if something
# goes wrong. Adrian's landmark detector may give warnings about
# certain packages being unavailable (e.g. libmatio), but they are not
# required.
pushd face-alignment > /dev/null
th main.lua -model 2D-FAN-300W.t7 \
   -input ../$INPUT/ \
   -detectFaces true \
   -mode generate \
   -output ../$INPUT/ \
   -device gpu \
   -outputFormat txt
popd > /dev/null

# Using awk we will find the bounding boxes from the detected points.
pushd $INPUT > /dev/null
ls -1 *.txt | \
    while read fname; do
	awk -F, 'BEGIN {
                   minX=1000;
                   maxX=0;
                   minY=1000;
                   maxY=0;
                 }
                 $1 > maxX { maxX=$1 }
                 $1 < minX { minX=$1 }
                 $2 > maxY { maxY=$2 }
                 $2 < minY { minY=$2 }
                 END {
                   scale=90/sqrt((minX-maxX)*(minY-maxY));
                   width=maxX-minX;
                   height=maxY-minY;
                   cenX=width/2;
                   cenY=height/2;
                   printf "%s %s %s %s\n",
                     FILENAME,
                     (minX-cenX)*scale,
                     (minY-cenY)*scale,
                     (scale)*100
        }' $fname
    done > crop.tmp

# And now using ImageMagick convert we will crop the faces.
cat crop.tmp | sed 's/.txt/.jpg/' | \
    while read fname x y scale; do
	convert $fname \
		-scale $scale% \
		-crop 192x192+$x+$y \
		-background white \
		-gravity center \
		-extent 192x192 \
		scaled/$fname
	 echo "Cropped and scaled $fname"
     done

rm crop.tmp
popd > /dev/null

# Pass the cropped image through VRN.
th process.lua \
   --model $VRN_MODEL \
   --input $INPUT/scaled \
   --output $OUTPUT \
   --device gpu

# Visualise the rendered model.
pushd output > /dev/null
ls -1 *.raw | sed 's/.raw//' | while read fname ; do
    python ../vis.py \
	   --image ../$INPUT/scaled/$fname.jpg \
	   --volume $fname.raw
    done
popd > /dev/null

