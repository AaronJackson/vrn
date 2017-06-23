% This script simplifies the process of running VRN. Assuming
% everything is set up according to the README file, it should work
% fine.

clear all, close all, clc

% Define some parameters.
input_folder = 'examples/';
output_folder = 'output/';
model_file = 'vrn-unguided.t7';
gpunum = 0;

% Make sure the output directory exists.
if ~exist(output_folder, 'dir')
    mkdir(output_folder)
end

% Run the Lua script to process the images and produce the 3D volumes.
retval = system(['CUDA_VISIBLE_DEVICES=' num2str(gpunum) ...
                    'th ' pwd '/process.lua' ...
                    ' --model ' model_file ...
                    ' --input ' input_folder ...
                    ' --output ' output_folder]);

if retval ~= 0
    error('Failed to run Torch7 script.')
end

% Visualise the output from VRN.
vols = dir([output_folder '/*.raw']);

for f=1:numel(vols)
    fname = vols(f).name(1:end-4);

    rendervol([input_folder fname '.jpg'], ...
              [output_folder fname '.raw']);
    rotate3d % allow dragging in 3D.

    fprintf('Rendered %s.\n', fname);
end

fprintf('All images rendered.\n');
