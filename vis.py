import numpy as np
import visvis as vv
import argparse

parser = argparse.ArgumentParser(description='Visualise the 3D volume')
parser.add_argument('--image', dest='image',
                    help="The background image to display")
parser.add_argument('--volume', dest='volume',
                    help="The volume to render")
parser.add_argument('--texture', dest='texture',
                    help="Show textured mesh NOT YET IMPLEMENTED")

args = parser.parse_args()

vol = np.fromfile(args.volume, dtype=np.int8)
vol = vol.reshape((200,192,192))

im = vv.imread(args.image)

t = vv.imshow(im)
t.interpolate = True # interpolate pixels

# volshow will use volshow3 and rendering the isosurface if OpenGL
# version is >= 2.0. Otherwise, it will show slices with bars that you
# can move (much less useful).
volRGB = np.stack(((vol > 1) * im[:,:,0],
                   (vol > 1) * im[:,:,1],
                   (vol > 1) * im[:,:,2]), axis=3)

v = vv.volshow(volRGB, renderStyle='iso')
v.transformations[1].sz = 0.5 # Z was twice as deep during training

l0 = vv.gca()
l0.light0.ambient = 0.9 # 0.2 is default for light 0
l0.light0.diffuse = 1.0 # 1.0 is default

a = vv.gca()
a.camera.fov = 0 # orthographic

vv.use().Run()


