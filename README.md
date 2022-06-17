# Label3D

Label3D is a GUI for the manual labeling of 3D keypoints in multiple cameras.
![Label3D Animation] <(common/label3dAnimation.gif)>

## Camera Code for Rodent3D dataset
--Camera1: blue (D415 137322076445)
--Camera2: pink (D415 137322076528)
--Camera3: yellow (D415 138422073715)
--Camera4: orange
--Camera5: green
--Camera6: red


## Installation

Label3D is dependent on other git repositories. To install dependencies recursively use:

```
git clone  --recurse-submodules https://github.com/Even/Label3D.git
```


## Features
1. Simultaneous viewing of any number of camera views
2. Multiview triangulation of 3D keypoints
3. Point-and-click and draggable gestures to label keypoints
4. Zooming, panning, and other default Matlab gestures
5. Integration with `Animator` classes

## Usage
Requires `Matlab 2019b`, `Matlab 2020a`, or `Matlab 2020b`

Label3D takes a cell arrays of structs of camera parameters as in
https://github.com/spoonsso/DANNCE, a cell array of corresponding videos (h,w,c,N),
and a skeleton struct defining a directed graph. Please look at `example.m`
for examples on how to format data.

```
labelGui = Label3D(params, videos, skeleton);
```

## [Manual](https://github.com/diegoaldarondo/Label3D/wiki)
* [About](https://github.com/diegoaldarondo/Label3D/wiki/About)
* [Documentation](https://github.com/diegoaldarondo/Label3D/wiki/Documentation)
* [Gestures and hotkeys](https://github.com/diegoaldarondo/Label3D/wiki/Gestures-and-hotkeys)
* [Setup](https://github.com/diegoaldarondo/Label3D/wiki/Setup)

Written by Diego Aldarondo (2019)

Some code adapted from https://github.com/talmo/leap
