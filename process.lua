#!/usr/bin/env th
local nn = require 'nn'
local cunn = require 'cunn'
local cudnn = require 'cudnn'
local image = require 'image'

cmd = torch.CmdLine()
cmd:option('--model', 'model.t7', 'Trained network model')
cmd:option('--input', 'examples/', 'Directory of images to process')
cmd:option('--output', 'output/', 'Location to dump output')
-- cmd:option('--crop', '384', 'Centre crop amount prior to scaling')

opt = cmd:parse(arg or {})

net = torch.load(opt.model):cuda()

for fname in paths.iterfiles(opt.input .. '/', '*.jpg') do
   fname = string.sub(fname, 1, -5)

   local img = image.load(opt.input .. '/' .. fname .. '.jpg')
   -- img = image.crop(img, 'c', tonumber(opt.crop), tonumber(opt.crop))
   img = image.scale(img, 192, 192)
   img = img:view(1,3,192,192):cuda()

   local output = net:forward(img)

   local vol = (output[1]*255):byte()

   local out = torch.DiskFile(opt.output .. '/' .. fname .. '.raw', 'w')
   out:binary()
   out:writeByte(vol:storage())
   out:close()

   io.write('Processed ' .. fname .. '.\n')
end
