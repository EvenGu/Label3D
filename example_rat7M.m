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
danncePath = 'C:\Users\g2121\Projects\Label3D';

%% Load in the calibration parameter data from MoCap data

% projectFolder = fullfile(danncePath,'s1-d1');
projectFolder = 'C:\Users\g2121\Projects\MoCap\s1-d1';
% calibPaths = collectCalibrationPaths(projectFolder);
% params = cellfun(@(X) {load(X)}, calibPaths);

numCams = 6;
mocapFile = 'mocap-s1-d1.mat';
% load([projectFolder filesep mocapFile])
load(mocapFile)
params = cell(numCams,1);
% extrinsics
% r = rotation matrix
% t = translation matrix
% intrinsics
% K = intrinsic matrix
% RDistort = RadialDistortion
% TDistort = TangentialDistortion

for i = 1:numCams
    params{i}.r = cameras.(['Camera' num2str(i)]).rotationMatrix;
    params{i}.t = cameras.(['Camera' num2str(i)]).translationVector;
    params{i}.K = cameras.(['Camera' num2str(i)]).IntrinsicMatrix;
    params{i}.RDistort = cameras.(['Camera' num2str(i)]).RadialDistortion;
    params{i}.TDistort = double(cameras.(['Camera' num2str(i)]).TangentialDistortion);
end


%% Load the videos into memory
% vidPrefix = 's1-d1-camera*-';
vidPrefix = '';
vidName = '0.mp4';
vidPaths = collectVideoPaths(projectFolder,[vidPrefix vidName]);
% vidPaths = collectVideoPaths([projectFolder filesep vidPrefix filesep vidName]);
videos = cell(numCams,1);
sync = collectSyncPaths(projectFolder, '*.mat');
sync = cellfun(@(X) {load(X)}, sync);

% In case the demo folder uses the dannce.mat data format. 
if isempty(sync)
    dannce_file = dir(fullfile(projectFolder, '*dannce.mat'));
    dannce = load(fullfile(dannce_file(1).folder, dannce_file(1).name));
    sync = dannce.sync;
    params = dannce.params;
end

nFrames = length(sync{1,1}.data_frame);

% framesToLabel = 1:100; % For debug etc
framesToLabel = 1: 350; 
for nVid = 1:numel(vidPaths)
    frameInds = sync{nVid}.data_frame(framesToLabel);
    videos{nVid} = readFrames(vidPaths{nVid}, frameInds+1);
end

%% Get the skeleton
skeleton = load('skeletons/Rat7M_20.mat');

%% Start Label3D
close all
% labelGui = Label3D(params, videos, skeleton);
labelGui = Label3D(params, videos, skeleton, 'sync', sync, 'framesToLabel', framesToLabel);

%% Load mocap data as 3D ground truth (nFrames, 3, nKeypoints)

mocapCell = struct2cell(mocap);
gt = cat(3, mocapCell{:});
labelGui.loadFrom3D(gt(framesToLabel,:,:));

%% Accept all and export to Dannce
labelGui.savePath = projectFolder;
labelGui.exportDannce('AcceptInit', 1);

%% Check the camera positions
labelGui.plotCameras       

%% If you just wish to view labels, use View 3D
close all
viewGui = View3D(params, videos, skeleton);

%% You can load both in different ways
close all;
View3D()