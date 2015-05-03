% maze = click_change_maze(maze)
% By Jeremy Kubica, Copyright 2003
%
% Displays the maze and allows you to interactively modify its configuration.
% Type 'help maze' for more information
function maze = click_change_maze(maze)

R = maze.R;
C = maze.C;

% Draw the maze and the "done button"
draw_maze(maze);
h1 = figure(1);
set(h1,'DoubleBuffer','on')
hold on;

patch([0 0 C C],[0 1 1 0],'r');
text(floor(C/2),0.2,'DONE');
drawnow

still_using = 1;
while(still_using == 1)
   
   % Get the next user input
   [X,Y] = ginput(1);
   
   % check if we should quit (i.e. done has been clicked)
   if((X<C)&(X>0)&(Y<1)&(Y>0))
      still_using = 0;
   else
      
      xErr = abs(X-round(X));
      yErr = abs(Y-round(Y));
      
      % determine the cell it was in
      Yi = R - (floor(Y)-2);
      Xi = ceil(X);
      ind = (Xi-1)*R + Yi;
      
      % do simple bounds checking
      if((X < 0)|(X>C)|(ind > R*C)|(Y<2)|(Y>R+2))
         ind = -1;
      end
      
      % determine if it was a veritcal line
      if( (xErr < 0.25) & (xErr < yErr) & (ind > 0) )

         % Determine if it was the east or west line
         if(round(X) == floor(X))  % line was west
            if(Xi > 1)
               maze.adjacent(ind-R,2) = 1-maze.adjacent(ind-R,2);
               maze.adjacent(ind,4) = 1-maze.adjacent(ind,4);
            end
         else                      % line was east
            if(Xi < C)
               maze.adjacent(ind,2) = 1-maze.adjacent(ind,2);
               maze.adjacent(ind+R,4) = 1-maze.adjacent(ind+R,4);
            end
         end
         
      end
      
      % determine if it was a horizontal line
      if( (yErr < 0.25) & (yErr < xErr) & (ind > 0) )

         % Determine if it was the northern or southern border
         if(round(Y) == floor(Y))  % border is southern
            if(Yi < R)
               maze.adjacent(ind+1,1) = 1-maze.adjacent(ind+1,1);
               maze.adjacent(ind,3) = 1-maze.adjacent(ind,3);
            end
         else                      % border is northern
            if(Yi > 1)
               maze.adjacent(ind-1,3) = 1-maze.adjacent(ind-1,3);
               maze.adjacent(ind,1) = 1-maze.adjacent(ind,1);
            end
         end
      end
    
   end
   
   % redraw the graph
   draw_maze(maze);
   patch([0 0 C C],[0 1 1 0],'r');
   text(floor(C/2),0.25,'DONE');
   drawnow;
   
end

% close the figure window
close(h1);