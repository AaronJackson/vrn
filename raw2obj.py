import numpy as np
import scipy.misc
import mcubes
import argparse
from sklearn.neighbors import NearestNeighbors


parser = argparse.ArgumentParser(description='Visualise the 3D volume')
parser.add_argument('--image', dest='image',
                    help="The background image to display")
parser.add_argument('--volume', dest='volume',
                    help="The volume to render")
parser.add_argument('--obj', dest='obj',
                    help="The file path of the object")

args = parser.parse_args()

im = scipy.misc.imread(args.image, False, 'RGB')

vol = np.fromfile(args.volume, dtype=np.int8)
vol = vol.reshape((200,192,192))
vol = vol.astype(float)

vertices, triangles = mcubes.marching_cubes(vol, 10)
vertices = vertices[:,(2,1,0)]
vertices[:,2] *= 0.5 # scale the Z component correctly

r = im[:,:,0].flatten()
g = im[:,:,1].flatten()
b = im[:,:,2].flatten()

vcx,vcy = np.meshgrid(np.arange(0,192),np.arange(0,192))
vcx = vcx.flatten()
vcy = vcy.flatten()
vc = np.vstack((vcx, vcy, r, g, b)).transpose()
neigh = NearestNeighbors(n_neighbors=1)
neigh.fit(vc[:,:2])
n = neigh.kneighbors(vertices[:,(0,1)], return_distance=False)
colour = vc[n,2:].reshape((vertices.shape[0],3)).astype(float) / 255

vc = np.hstack((vertices, colour))

with open(args.obj, 'w') as f:
    for v in range(0,vc.shape[0]):
        f.write('v %0.2f %0.2f %0.2f %0.2f %0.2f %0.2f\n' % (vc[v,0],vc[v,1],vc[v,2],vc[v,3],vc[v,4],vc[v,5]))

    for t in range(0,triangles.shape[0]):
        f.write('f {} {} {}\n'.format(*triangles[t,:]+1))

print('Calculated the isosurface.')
