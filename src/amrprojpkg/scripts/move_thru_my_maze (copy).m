%**************************************************************************
%ECE595-008 Autonomous Mobile Robots - Final Project

%This is the main program that will move the robot through the maze stated
%in the proposal. It will use only the bare minimim of functions,mainly the
%'is_move_valid' function, from the downloaded maze tool box. The program 
%will command the robot to move one cell at a time along a designated path
%(straight line segment)of the maze until until it reaches the end of the
%path. It will then be directed to turn and then a new path command path 
%will be initiated. This pattern will be repeated until the robot confirms
%findiing the target or reaches the end of the maze. The robot will start 
%at cell 62 and will end at cell 87 if no target is found.

%In order to search the entire maze, 19 predetermined paths will be pre-
%programmed into the search. This will be performed with the function:

%function nindex = is_move_valid(maze,index,move)

%where:
% 'maze'     is the currently loaded proposed maze
% 'index'    is the current robot location in the maze
% 'move'     is 1 of 4 possible values indicating the current desired 
%            direction to travel indicated as follows:
%               move = 1 -> NORTH
%               move = 2 -> EAST
%               move = 3 -> SOUTH
%               move = 4 -> WEST
%nindex     is the new location in the maze. This value will be fed-back to
%           future values of 'index' for continuous movement

%Each path of the maze will be coded as follows:
%path(i)=[a b c] where:
    %a = starting index of path(i)
    %b = # of cells to move in path(i)
    %c = direction of movement in path(i) using 'move' code above

%The physical length of one cell = physical length of the robot

%Coded action commands to the robot will be written as integers to the 
%variable 'to_robot' and decoded with the following key:

%   1 => move forward 1 cell
% -90 => turn left 90 degrees
%  90 => turn right 90 degrees
% 180 => turn around 180

%**************************************************************************

clc;clear;close all

p=1; %seconds to pause

lc=1;   %switch for displaying index numbers in maze
to_robot=0; %mailbox for coded integer for robot action

%load and draw maze
maze=load_maze('my_maze'); %loads proposal maze

%maze paths
path1=[62 6 1];    %Path 1
path2=[56 5 4];    %Path 2
path3=[11 4 3];    %Path 3
path4=[15 1 2];    %Path 4
path5=[24 3 1];    %Path 5
path6=[21 2 2];    %Path 6
path7=[39 2 3];    %Path 7
path8=[41 2 1];    %Path 8
path9=[39 2 4];    %Path 9
path10=[21 3 3];   %Path 10
path11=[24 1 4];   %Path 11
path12=[15 4 1];   %Path 12
path13=[11 10 2];   %Path 13
path14=[101 2 3];   %Path 14
path15=[103 2 2];   %Path 15
path16=[121 1 1];   %Path 16
path17=[120 2 2];   %Path 17
path18=[138 3 3];   %Path 18
path19=[141 6 4];   %Path 19


%Setting up ROS publisher 'chatter' then publishing 0
chatpub=rospublisher('/chatter','std_msgs/Int16');
send_zero();

disp('Start robot script then press ENTER'),pause

%Can remove later when loops are working
%Subscribing to 'feedback' topic created by Pithon script
sub=rossubscriber('/feedback');
fb=receive(sub);    %checking subscriber
fb=fb.Data;

%moving robot through Path 1
disp('Path 1')
index=path1(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path1(2)  
    disp('start of loop')
    
    %check for 'F' here for object found
    sub=rossubscriber('/feedback');
    fb=receive(sub);    %checking subscriber
	fb=fb.Data;
    if fb=='F'
       disp('OBJECT FOUND!!')
       pause(2*p)
       return,return,return
    end
    
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path1(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path2(3)-path1(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
                                                                                                        
%moving robot through Path 2
disp('Path 2')
index=path2(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path2(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path2(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path3(3)-path2(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
%moving robot through Path 3
disp('Path 3')
index=path3(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path3(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path3(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path4(3)-path3(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
%moving robot through Path 4
disp('Path 4')
index=path4(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path4(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path4(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path5(3)-path4(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
%moving robot through Path 5
disp('Path 5')
index=path5(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path5(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path5(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path6(3)-path5(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
   
%moving robot through Path 6
disp('Path 6')
index=path6(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path6(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path6(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path7(3)-path6(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
%moving robot through Path 7
disp('Path 7')
index=path7(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path7(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path7(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path8(3)-path7(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
%moving robot through Path 8
disp('Path 8')
index=path8(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path8(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path8(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path9(3)-path8(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    
%moving robot through Path 9
disp('Path 9')
index=path9(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path9(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path9(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path10(3)-path9(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    
%moving robot through Path 10
disp('Path 10')
index=path10(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path10(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path10(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path11(3)-path10(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    
%moving robot through Path 11
disp('Path 11')
index=path11(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path11(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path11(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path12(3)-path11(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    
%moving robot through Path 12
disp('Path 12')
index=path12(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path12(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path12(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path13(3)-path12(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    
%moving robot through Path 13
disp('Path 13')
index=path13(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path13(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path13(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path14(3)-path13(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    
%moving robot through Path 14
disp('Path 14')
index=path14(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path14(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path14(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path15(3)-path14(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    
%moving robot through Path 15
disp('Path 15')
index=path15(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path15(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path15(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path16(3)-path15(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    
%moving robot through Path 16
disp('Path 16')
index=path16(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path16(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path16(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        send(chatpub,msg);
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path17(3)-path16(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    
%moving robot through Path 17
disp('Path 17')
index=path17(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path17(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path17(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        send(chatpub,msg);
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path18(3)-path17(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    
%moving robot through Path 18
disp('Path 18')
index=path18(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path18(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path18(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        send(chatpub,msg);
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end

%determine turn angle for next path-calculated from truth table
tid=path19(3)-path18(3);               %tid => turn index difference
if (tid==1 |tid==-3)
    ta=90;                           %ta => turn angle
elseif(tid==-1 | tid==3)
    ta=-90;
else
    ta=180;
end

%Tell robot to turn
msg=rosmessage(chatpub);
msg.Data=ta;
send(chatpub,msg);
pause(p);
to_robot=ta                 %this is just a screen message

disp('     awaiting confirm'),      %replace with loop structure awaiting
                                    %confirm message from robot

while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    
%moving robot through Path 19 (last path)
disp('Path 19')
index=path19(1)
draw_maze(maze,lc,index)%draws proposal maze-intended position highlighted
for i=1:path19(2)  
    disp('start of loop')
    %check for 'F' here
    while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
    end
    
    %Tell robot to move 1 cell
    msg=rosmessage(chatpub);
    msg.Data=1;
    send(chatpub,msg);
    pause(p);
    to_robot=1                  %this is just a screen message
    
    
    %Awaiting confirmation from robot that it has moved one cell
    disp('     awaiting confirm')%remove pause eventually
    
    while fb ~= 'N'  %Eventually change to 'N
        sub=rossubscriber('/feedback');
        fb=receive(sub);    %checking subscriber.fb=>feedback
        fb=fb.Data
    end                                 
    disp('     confirmed')
    
    %Tell robot to wait
    send_zero();
    
    index = is_move_valid(maze,index,path19(3))     %move north 1 cell
    draw_maze(maze,lc,index)    %maze redrawn w/current position highlighted
    pause(p);
        
end

 while fb ~= 'Y'
        %Subscribing to 'feedback' topic created by Pithon script
        sub=rossubscriber('/feedback');
        send(chatpub,msg);
        fb=receive(sub);   %checking subscriber.fb=>feedback
        fb=fb.Data;
 end
    
    
    
    
    
    
