function vol = readvol(path, dims)
% This method will parse the raw files dumped by the Lua script and
% return a 3D matrix of intensity values. This can then be
% visualised using isosurface.

if nargin < 2
    dims = [ 192 192 200 ];
end

fid = fopen(path);
if fid < 0
    error(['Failed to open ' path])
end

vol = fread(fid, 'uint8');
fclose(fid);
vol = reshape(vol, dims);
vol = permute(vol, [2 1 3]);