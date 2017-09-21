#!/usr/bin/env th
local nn = require 'nn'
local image = require 'image'

cmd = torch.CmdLine()
cmd:option('--model', 'model.t7', 'Trained network model')
cmd:option('--input', 'examples/', 'Directory of images to process')
cmd:option('--output', 'output/', 'Location to dump output')
cmd:option('--device', 'gpu', 'GPU or CPU')

opt = cmd:parse(arg or {})

net = torch.load(opt.model)

if opt.device == 'gpu' then
   local cunn = require 'cunn'
   local cudnn = require 'cudnn'
   net = net:cuda()
end

for fname in paths.iterfiles(opt.input .. '/', '*.jpg') do
   fname = string.sub(fname, 1, -5)

   local img = image.load(opt.input .. '/' .. fname .. '.jpg')
   img = image.scale(img, 192, 192)
   img = img:view(1,3,192,192):float()
   if opt.device == 'gpu' then
      img = img:cuda()
   end

   local output = net:forward(img)

   local vol = (output[1]*255):byte()

   local out = torch.DiskFile(opt.output .. '/' .. fname .. '.raw', 'w')
   out:binary()
   out:writeByte(vol:storage())
   out:close()

   io.write('Processed ' .. fname .. '.\n')
end
