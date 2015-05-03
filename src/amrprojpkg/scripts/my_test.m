%Test Script

clc;clear;close all

% X=17;    %matrix dimensions
% Y=9;     %matrix dimensions
lc=1;      % => label cells?,lc=0 => no,lc=1 => yes
index0=62 %starting index of search

%THIS BLOCK OF CODE USED FOR LEARNING AND GENERATING PROPOSAL MAZE

%create blank maze
%is called by 'generate_maze'so not needed in main calling routine
%bm=create_blank_maze(5,5) %create a 5X5 blank maze

% %generates a random unique solution maze
% maze=generate_maze(X,Y)
% 
% %draw the maze 
% draw_maze(maze,lc)

%modify the maze
%maze=click_change_maze(maze)


%THIS BLOCK OF CODE LOADS PROPOSAL MAZE AND CONTINUES LEARNING PROCESS
maze=load_maze('my_maze'); %loads proposal maze
draw_maze(maze,lc)         %draws proposal maze in stated manner
%GOOD TO HERE

%THINGS TO DO HERE:
%(a)Write movements in loop structure
%(b)Does Jake need new rel pos to move to or rel delta pos/dir?
%(c)Do I have to move 1 block at a time? ANS:I believe YES
%(d)After for example a left turn, does the robot know that it is going
%left or thinks it's going forward after turning?

%define origin
[Xa0,Ya0] = maze_XY_from_index(maze,index0);  
XY_a0=[Xa0,Ya0]                             %absolute coordinates of origin
Xr0=Xa0-Xa0;Yr0=Ya0-Ya0;                     
XY_r0=[Xr0,Yr0]                             %rel coordinates of origin (0,0)

disp('make move 1')
index1 = is_move_valid(maze,index0,1)     %move north 1 block
[Xa1,Ya1] = maze_XY_from_index(maze,index1);
XY_a1=[Xa1,Ya1]                           %absolute coordinates after move 1
XY_r1=[Xa1-Xa0,Ya0-Ya1]                   %rel coordinates of origin (0,0)

disp('make move 2')
index2 = is_move_valid(maze,index1,1)     %move north 1 block
[Xa2,Ya2] = maze_XY_from_index(maze,index2);
XY_a2=[Xa2,Ya2]                           %absolute coordinates after move 1
XY_r2=[Xa2-Xa0,Ya0-Ya2]                   %rel coordinates of origin (0,0)
