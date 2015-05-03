% Maze Toolbox
% Version 0.1    16-Jan-2003
% By Jeremy Kubica, Copyright 2003
%
% The maze toolbox is a collection of simple files to generate, display, save, and
% load simple maze representations.
% If you distribute the code, please include ALL MATLAB files and the README file.
%
% A maze is represented by a single Boolean matrix representing whether it is possible
% to move from a given cell is possible in each of the four directions (North, East, South,
% and West).  Each row in the matrix corresponds to exactly one grid space in the maze and
% each column corresponds to one direction.
%
% Maze squares are indexed in column order from North to South, then West to East.  
% For example, the squares in a 3x4 grid would have indices:
%
%    1  5  7  10
%    2  4  8  11
%    3  6  9  12
%
% Movement between nodes in the maze is accomplished by directly calculating the successor node's index.
% Specifically, we can define the movements on an Y by X maze as:
%   Move(North): ind = ind - 1
%   Move(South): ind = ind + 1
%   Move(East): ind = ind + Y
%   Move(West): ind = ind - Y
% with the appropriate checks on the bounds and validity of movements.
%
%
% FUNCTIONS:
%
% Movement functions
%   maze_XY_from_index - Gets the X and Y coordinates of the location at index.
%   maze_index_from_XY - Gets the index from the X and Y coordinates.
%   is_move_valid      - Checks the validity and determines the result of a move.
%
% Maze generation and modification functions
%   generate_maze      - Generates a valid (single unique solution) maze.
%   click_change_maze  - Allows interactive maze creation/modification.
%   create_blank_maze  - Creates a "blank" maze.
%
% Display Functions:
%   draw_maze          - Displays the maze.
%
% File IO Functions:
%   load_maze          - Loads a maze file into Matlab.
%   save_maze          - Saves a maze file.