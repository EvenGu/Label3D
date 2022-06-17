%% Example setup for Label3D
% Label3D is a GUI for manual labeling of 3D keypoints in multiple cameras. 
% 
% Its main features include:
% 1. Simultaneous viewing of any number of camera views. 
% 2. Multiview triangulation of 3D keypoints.
% 3. Point-and-click and draggable gestures to label keypoints. 
% 4. Zooming, panning, and other default Matlab gestures
% 5. Integration with Animator classes. 
% 6. Support for editing prelabeled data.
% 
% Instructions:
% right: move forward one frameRate
% left: move backward one frameRate
% up: increase the frameRate
% down: decrease the frameRate
% t: triangulate points in current frame that have been labeled in at least two images and reproject into each image
% r: reset gui to the first frame and remove Animator restrictions
% u: reset the current frame to the initial marker positions
% z: Toggle zoom state
% p: Show 3d animation plot of the triangulated points. 
% backspace: reset currently held node (first click and hold, then
%            backspace to delete)
% pageup: Set the selectedNode to the first node
% tab: shift the selected node by 1
% shift+tab: shift the selected node by -1
% h: print help messages for all Animators
% shift+s: Save the data to a .mat file
clear all
close all;
addpath(genpath('deps'))
addpath(genpath('skeletons'))
% TODO: load data
% projectFolder = 'C:\Users\g2121\Projects\DATA\Rodent3D'; 
% calibFile = 'C:\Users\g2121\Projects\DATA\Rodent3D\2022-05-11_camera_params_man1.mat'; 
projectFolder = 'C:\Users\g2121\Projects\dannce\00_Rodent\2022-05-18';
addpath(projectFolder);
calibFile = '2022-05-11_camera_params_fromcp.mat';
% construct params
load(calibFile);
numCams = 6;
params = cell(numCams,1);
for i = 1:numCams
    params{i}.r = rotationMatrix{i};
    params{i}.t = translationVector{i};
    params{i}.K = params_individual{i}.IntrinsicMatrix;
    params{i}.RDistort = params_individual{i}.RadialDistortion;
    params{i}.TDistort = params_individual{i}.TangentialDistortion;
end
%% Load the videos into memory
vidName = '0.mp4';
vidPaths = collectVideoPaths(projectFolder,vidName);
videos = cell(numCams,1);
sync = collectSyncPaths(projectFolder, '*.mat');
sync = cellfun(@(X) {load(X)}, sync);

framesToLabel = 1:50; % This needs to be same 
for nVid = 1:numel(vidPaths)
    frameInds = sync{nVid}.data_frame(framesToLabel);
    videos{nVid} = readFrames(vidPaths{nVid}, frameInds+1);
%     try
%         videos{nVid} = readFrames(vidPaths{nVid}, frameInds+1);
%     catch ME
%         disp(ME)
%         v = VideoReader(vidPaths{nVid});
%         videos{nVid} = read(v, frameInds+1);
%     end
end

%% Get the skeleton
skeleton = load('skeletons/rodent3d_12_skeleton');
%% Start Label3D
close all
% labelGui = Label3D(params, videos, skeleton);
labelGui = Label3D(params, videos, skeleton, 'sync', sync, 'framesToLabel', framesToLabel);

%% Check the camera positions
labelGui.plotCameras       

%% If you just wish to view labels, use View 3D
close all
viewGui = View3D(params, videos, skeleton);

%% You can load both in different ways
close all;
View3D()