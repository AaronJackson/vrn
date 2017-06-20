+====================================================================+
|          Large Pose 3D Face Reconstruction from a Single           |
|            Image via Direct Volumetric CNN Regression              |
|====================================================================|
|                                                                    |
| Aaron S. Jackson       <aaron.jackson@nottingham.ac.uk>            |
| Adrian Bulat           <adrian.bulat@nottingham.ac.uk>             |
| Vasileios Argyriou     <vasileios.argyriou@kingston.ac.uk>         |
| Georgios Tzimiropoulos <yorgos.tzimiropoulos@nottingham.ac.uk>     |
|                                                                    |
| http://aaronsplace.co.uk/papers/jackson2017recon/                  |
|                                                                    |
+====================================================================+

Last Updated:

     Tue 20 Jun 13:38:18 BST 2017


List of files:

 ./README           This file explaining how to run the code.
 ./vrn.t7           The CNN model for Torch7.
 ./test.lua         Torch script for running reconstruction.
 ./read_raw.m       MATLAB function for reading loading volumes.
 ./render.m         MATLAB script to plot the results.


Requirements:

 A working installation of Torch7 is required. This can be installed
 easily on most platforms using [1]. You will also requried a
 reasonable CUDA capable GPU. We trained our method using NVIDIA Titan
 X. This unguided implementation needs about 1.2GB of video RAM in
 order to process the an image of 192x192. MATLAB is used to render
 the isosurface of the 3D volume, but other raw volumetric rendering
 programs also exist, which could be used instead.

 Overview:

  Torch7 (+ nn, cunn, cudnn, image)
  MATLAB
  NVIDIA GPU (+ CUDA, CuDNN)


Usage:

 Assuming you have the dependencies installed correctly, you should be
 able to run "./th test.lua" and it will process the included example
 images.

 Once the images are processed, which should only take a few seconds,
 the "render.m" script can be called from MATLAB, which will render
 the 3D face on top of the input image.


Using your own images:

 You can use your own images with this method, since no landmarks are
 required. However, while we trained with large variation in scale,
 please be aware that on very small or very large faces, the method
 may begin to produce poor results.

 All images are given to the network as 192x192, so it would be best
 to make sure your image is square before passing it to the network.



======================================================================

[1] https://github.com/torch/distro
    Torch installation in a self contained folder.